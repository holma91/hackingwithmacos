//
//  ContentView.swift
//  AnimationSandbox
//
//  Created by Alexander on 2023-01-23.
//

import SwiftUI

struct ContentView: View {
  @State private var isShowingRed = false
  
  var body: some View {
    VStack {
      Button("Click Me") {
        withAnimation {
          isShowingRed.toggle()
        }
      }
      if isShowingRed {
        Rectangle()
          .fill(.red)
          .frame(width: 200, height: 200)
      }
    }
    .frame(width: 300, height: 300)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
