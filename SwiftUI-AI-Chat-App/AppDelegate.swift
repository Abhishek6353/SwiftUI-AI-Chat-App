//
//  AppDelegate.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         FirebaseApp.configure()
        return true
    }
}

