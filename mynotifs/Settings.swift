//
//  Settings.swift
//  PokeRadar
//
//  Created by surendra kumar on 5/5/18.
//  Copyright © 2018 weza. All rights reserved.
//

import Foundation
import UIKit

let APP_ID = "1104988123"
let APP_URL = "https://itunes.apple.com/us/app/private-for-youtube/id1104988123?ls=1&mt=8"
let DESCRIPTION = "Hey, Find nearby Pokemon"

class Settings : UITableViewController{
 
    @IBAction func rateUS(_ sender: Any) {
        let url : URL = URL(string: "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(APP_ID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=7")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func share(_ sender: Any) {
        let acivity1 = DESCRIPTION
        let activity2 = APP_URL
        let activity = UIActivityViewController(activityItems: [acivity1,activity2], applicationActivities: nil)
        
        
        activity.popoverPresentationController?.sourceView = self.view
        
        present(activity, animated: true, completion: nil)
    }
    @IBAction func help(_ sender: Any) {
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
