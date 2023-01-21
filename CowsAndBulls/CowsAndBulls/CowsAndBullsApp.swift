//
//  CowsAndBullsApp.swift
//  CowsAndBulls
//
//  Created by Alexander on 2023-01-20.
//

import SwiftUI

@main
struct CowsAndBullsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
      
      Settings(content: SettingsView.init)
    }
}
