//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Alexander on 2023-01-21.
//

import SwiftUI

extension View {
  func titleStyle() -> some View {
      modifier(Title())
  }
  
  func blueTitleStyle() -> some View {
    modifier(BlueTitle())
  }
  
  func watermarked(with text: String) -> some View {
    modifier(Watermark(text: text))
  }
}

struct ContentView: View {
  var body: some View {
    VStack(spacing: 10) {
      CapsuleText(text: "First").foregroundColor(.white)
      Text("Hello World").titleStyle()
      Color.blue
        .frame(width: 300, height: 50)
        .watermarked(with: "Hacking with Swift")
      
      GridStack(rows: 4, columns: 4) { row, col in
        Text("R\(row)-C\(col)")
      }
      
      Text("idiot").blueTitleStyle()
    }
    .padding(70)
  }
}

struct GridStack<Content: View>: View {
  let rows: Int
  let columns: Int
  let content: (Int, Int) -> Content
  var body: some View {
    VStack {
      ForEach(0..<rows, id: \.self) { row in
        HStack {
          ForEach(0..<columns, id: \.self) { column in
            content(row, column)
          }
          
        }
      }
    }
  }
  
}

struct CapsuleText: View {
  var text: String
  var body: some View {
    Text(text)
      .font(.largeTitle)
      .padding()
      .background(.blue)
      .clipShape(Capsule())
  }
}

struct BlueTitle: ViewModifier {
  func body(content: Content) -> some View {
    content.font(.largeTitle).foregroundColor(.blue)
  }
}

struct Title: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)
      .foregroundColor(.white)
      .padding()
      .background(.blue)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

struct Watermark: ViewModifier {
  var text: String
  
  func body(content: Content) -> some View {
    VStack(spacing: 0) {
      content
      Text(text)
        .font(.title)
        .foregroundColor(.cyan)
        .padding(15)
        .background(.black)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
