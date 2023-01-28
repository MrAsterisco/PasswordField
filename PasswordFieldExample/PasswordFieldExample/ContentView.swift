//
//  ContentView.swift
//  PasswordFieldExample
//
//  Created by Alessio Moiso on 23.01.23.
//

import SwiftUI
import PasswordField

struct ContentView: View {
  @State private var username = ""
  @State private var password = ""
  
  @State private var isInputVisible = false
  
  var body: some View {
    Form {
      Section {
        PasswordField(text: $password)
      } header: {
        Text("Simple").bold()
      }
      
      Section {
        PasswordField(text: $password)
          .inputVisibile($isInputVisible)
          .visibilityControlPosition(.hidden)
        Toggle(isOn: $isInputVisible) {
          Text("Show Password")
        }
      } header: {
        Divider()
          .padding(.top, 20)
        Text("External Binding").bold()
      }
      
      Section {
        PasswordField(text: $password) { isInputVisible in
          Picker("", selection: isInputVisible) {
            Text("Visible")
              .tag(true)
            
            Text("Hidden")
              .tag(false)
          }
          .padding(.top, 4)
          #if !os(watchOS)
          .pickerStyle(.segmented)
          #endif
        }
        .visibilityControlPosition(.below)
      } header: {
        Divider()
          .padding(.top, 20)
        Text("Custom Visibility Control").bold()
      }
    }
    #if os(macOS)
    .padding()
    #endif
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
