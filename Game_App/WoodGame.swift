//
//  Game_AppApp.swift
//  Game_App
//
//  Created by Сергей Саченко on 12.02.2025.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct YourApp: App {
    // register app delegate for Firebase setupa
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("log_status") private var logStatus: Bool = false
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if logStatus {
                    ContentView() // Main View
                } else {
                    LoginView() // Enter View
                }
            }
        }
    }
}
