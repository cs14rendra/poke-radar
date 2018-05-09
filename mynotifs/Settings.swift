//
//  Settings.swift
//  PokeRadar
//
//  Created by surendra kumar on 5/5/18.
//  Copyright © 2018 weza. All rights reserved.
//

import Foundation
import UIKit

let APP_ID = "1381125391"
let APP_URL = "https://itunes.apple.com/us/app/poke-radar/id1381125391?ls=1&mt=8"
let DESCRIPTION = "Hey, Find nearby Pokemon using :"

class Settings : UITableViewController{
 
    @IBAction func rateUS(_ sender: Any) {
        let url : URL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=7")!
        
        let alert = UIAlertController(title: "Rate US", message: "If you Enjoy using this App, please rate us 5-star on App store. It would be greate encouragement for us to continue improving the product", preferredStyle: .alert)
        let action = UIAlertAction(title: "Rate", style: .default) { (action) in
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func share(_ sender: Any) {
        let acivity1 = DESCRIPTION
        let activity2 = APP_URL
        let activity = UIActivityViewController(activityItems: [acivity1,activity2], applicationActivities: nil)
        
        
        activity.popoverPresentationController?.sourceView = self.view
        
        present(activity, animated: true, completion: nil)
    }
    @IBAction func help(_ sender: Any) {
        let alert = WelcomeAlert().getAlertView()
        alert.show()
    }
    
    
    @IBAction func contribution(_ sender: Any) {
        loadUserTable()
    }
}

extension Settings{
    func loadUserTable(){
        let vc = PokeListVC() 
        vc.isUserTable = true
        vc.userPokeList = getPokeList() ?? []
        vc.textLB = "Pokemon types added by you:"
        present(vc, animated: true, completion: nil)
    }
    
    func getPokeList() -> [Int]?{
        let defaults = UserDefaults.standard
        let ary = defaults.array(forKey: "user") as? [Int]
        return ary
    }
}
