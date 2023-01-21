//
//  ContentView.swift
//  StormViewer
//
//  Created by Alexander on 2023-01-19.
//

import SwiftUI

struct ContentView: View {
  let names = ["Amy", "Charles", "Jake", "Rosa"]
  
  @State private var selectedImage: Int?
  
  
  var body: some View {
    NavigationSplitView {
      // bind the selection of our list to selectedImage
      List(0..<10, selection: $selectedImage) { number in
        Text("Storm \(number + 1)")
      }
      .frame(width: 150)
    } detail: {
      if let selectedImage = selectedImage {
        Image(String(selectedImage)).resizable().scaledToFit()
      } else {
        Text("Please select an image")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        .preferredColorScheme(.light)
    }
}
