//
//  AppDelegate.swift
//  Market
//
//  Created by Administrador on 10/3/19.
//  Copyright © 2019 Administrador. All rights reserved.
//

import UIKit
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        //Firebase
        FirebaseApp.configure()
        //initializePaypal()
        initializeStripe()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //MARK: - Paypal Init
//    func initializePaypal(){
////        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction : "AaYDFS86H8hLkcTeJSZghLUtvxwzxBMLcF72iIblNsyVbmBsqQ7DNxBAMHlWaP0oKcEXEYSLb6x1LvZI",PayPalEnvironmentSandbox:"sb-b66eh390723@personal.example.com"])
//
//         PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction :"AVmpCoX4_wF3oaiUaUk-413tVFtFxp-66OLX0zkjrE8yX1RqIbdvfkIDMhEPaBdk7kFwBF6M_9neyVWo"
//          , PayPalEnvironmentSandbox: "dkababian-facilitator@yahoo.com"])
//    }
    
    //MARK: Stripe init
    func initializeStripe(){
        STPPaymentConfiguration.shared().publishableKey = Constants.publishablekey
        StripeClient.sharedClient.baseURLString = Constants.baseURLString
    }

}

