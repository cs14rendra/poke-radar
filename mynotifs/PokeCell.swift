//
//  PokeCell.swift
//  PokeRadar
//
//  Created by surendra kumar on 5/5/18.
//  Copyright © 2018 weza. All rights reserved.
//

import UIKit

class PokeCell: UITableViewCell {

    @IBOutlet weak var lb: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var pokemonNumber : Int?{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var identifire : String{
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifire, bundle: nil)
    }
    
    func updateUI(){
        self.lb.text = pokemon[pokemonNumber!]
        let image = UIImage(named: "Marker")?.withRenderingMode(.alwaysTemplate)
        img.image = image?.imageWithColor(color1: colors[pokemonNumber! % (pokemon.count-1)])
    }
    
}
