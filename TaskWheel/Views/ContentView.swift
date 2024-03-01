//
//  ContentView.swift
//  TaskWheel
//
//  Created by Jiwoo on 2024-02-29.
//

import SwiftUI

struct ContentView: View {
  @State var selectedColor = "color"
  var colors = ["red", "green", "blue"]
  
  var body: some View {
    VStack {
      Text("You selected: \(selectedColor)")
      
      Picker("Choose a color", selection: $selectedColor) {
        ForEach(colors, id: \.self) {
          Text($0)
        }
      }
      .pickerStyle(.menu)
      .padding()
      .background(.clear)
      .padding()
    }
  }
}
#Preview {
    ContentView()
}
