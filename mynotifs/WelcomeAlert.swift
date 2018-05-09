//
//  WelcomeAlert.swift
//  PokeRadar
//
//  Created by surendra kumar on 5/5/18.
//  Copyright © 2018 weza. All rights reserved.
//

import Foundation
import AlertOnboarding
import UIKit


class WelcomeAlert {
    init() {
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        self.cutomizeAlertView()
    }
    
    let RED = UIColor.red
    var alertView: AlertOnboarding!
    var arrayOfImage = ["alert", "alert", "alert"]
    var arrayOfTitle = ["Find Pokemon", "Add Pokemon", "Navigate"]
    var arrayOfDescription = ["Nearby pokemon shows on map. User can filter pokemon using top left button.",
                              "Add a pokemon using plus button on bottm leftbutton whenever you get new pokemon at your location, pokemon will be add on server and other user can see its location in real time","User can easily navigate to pokemon location by tapping it"]
    
    func getAlertView() -> AlertOnboarding {
        return alertView
    }
    
    func cutomizeAlertView(){
        self.alertView.colorForAlertViewBackground = UIColor.white
        self.alertView.percentageRatioWidth = 0.97
        self.alertView.percentageRatioHeight = 0.95
        self.alertView.colorButtonText = RED
        self.alertView.colorCurrentPageIndicator = RED
        self.alertView.colorPageIndicator = RED.withAlphaComponent(0.30)
        self.alertView.colorTitleLabel = RED.withAlphaComponent(0.70)
        self.alertView.colorButtonBottomBackground = RED.withAlphaComponent(0.27)
        
        
    }
    
}
