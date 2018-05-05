//
//  PokeListVC.swift
//  PokeRadar
//
//  Created by surendra kumar on 5/5/18.
//  Copyright © 2018 weza. All rights reserved.
//

import UIKit

protocol PokeListVCDelegate {
    func didSelectPokemon(number : Int)
    func getSelelctedPokemon(pokemons : [Int])
}

class PokeListVC: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var lb: UILabel!
    var textLB : String = ""
    var delegate : PokeListVCDelegate?
    var isAllowMultSelection : Bool = false
    var isUserTable : Bool = false
    var userPokeList = [Int]()
    var selectedPokemon = [Int](){
        didSet{
            if selectedPokemon.isEmpty{
                self.btn.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.3) {
                    self.btn.setImage(UIImage(named: "dismiss"), for: .normal)
                    self.btn.transform = .identity
                }
                
            }else{
                self.btn.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.3) {
                    self.btn.setImage(UIImage(named: "ok"), for: .normal)
                    self.btn.transform = .identity
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lb.text = textLB
        myTable.delegate = self
        myTable.dataSource = self
        myTable.allowsMultipleSelection = isAllowMultSelection
        myTable.register(PokeCell.nib, forCellReuseIdentifier: PokeCell.identifire)
        for index in 0..<pokemon.count{
            selectedPokemon.append(index)
        }
        if !isAllowMultSelection{
             self.btn.setImage(UIImage(named: "dismiss"), for: .normal)
        }else{
            self.btn.setImage(UIImage(named: "ok"), for: .normal)
        }
    }
    override func loadView() {
        Bundle.main.loadNibNamed("PokeListVC", owner: self, options: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        if isAllowMultSelection{
            delegate?.getSelelctedPokemon(pokemons: selectedPokemon)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func ShowDialogAndDismiss(number : Int){
        let alert = UIAlertController(title: "Pokemon", message: "Selected pokemon \(pokemon[number]) will be added to your location.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.delegate?.didSelectPokemon(number: number)
            self.savePokemontoUserList(number: number)
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func savePokemontoUserList(number : Int){
        let defaults = UserDefaults.standard
        if let ary = defaults.array(forKey: "user") as? [Int]{
            if !ary.contains(number){
                var list = ary
                list.append(number)
                defaults.set(list, forKey: "user")
            }
        }else{
            let list = [number]
            defaults.set(list, forKey: "user")
        }
        
        
    }
}

extension PokeListVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isUserTable {
            return userPokeList.count
        }
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokeCell.identifire) as! PokeCell
        cell.pokemonNumber = indexPath.row
        if isAllowMultSelection{
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
            cell.isSelected = true
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAllowMultSelection{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            let index = selectedPokemon.index(of: indexPath.row)
            selectedPokemon.remove(at: index!)

        }else{
            ShowDialogAndDismiss(number: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        myTable.deselectRow(at: indexPath, animated: true)
        if isAllowMultSelection{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedPokemon.append(indexPath.row)
        }
    }
}
