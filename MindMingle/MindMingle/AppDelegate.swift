//
//  AppDelegate.swift
//  MindMingle
//
//  Created by MindMingle on 05/12/2023.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundMusic: AVAudioPlayer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Register custom font
            if let fontURL = Bundle.main.url(forResource: "YourCustomFont", withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, CTFontManagerScope.process, nil)
            }
        SoundManager.shared.playBackgroundMusic()
            return true
        }
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

func applicationDidEnterBackground(_ application: UIApplication) {
    SoundManager.shared.saveSettings()
}

func applicationDidFinishLaunching(_ application: UIApplication) {
    SoundManager.shared.loadSettings()
}

