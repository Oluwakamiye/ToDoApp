//
//  AppDelegate.swift
//  Todoey
//
//  Created by Oluwakamiye Akindele on 09/09/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("File Path is \(Realm.Configuration.defaultConfiguration.fileURL)")
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
