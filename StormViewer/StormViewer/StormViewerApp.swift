//
//  StormViewerApp.swift
//  StormViewer
//
//  Created by Alexander on 2023-01-19.
//

import SwiftUI

@main
struct StormViewerApp: App {
    var body: some Scene {
      Window("Storm Viewer", id: "main") {
          ContentView()
            .onAppear {
              NSWindow.allowsAutomaticWindowTabbing = false // equivalent doesn't exist in swiftui
            }
          
        }
        .commands {
          CommandGroup(replacing: .newItem) {  }
          CommandGroup(replacing: .undoRedo) {  }
          CommandGroup(replacing: .pasteboard) {  }
        }
    }
}
