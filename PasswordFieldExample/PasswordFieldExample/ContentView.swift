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
      Section("Simple") {
        TextField("Username", text: $username)
        PasswordField(text: $password)
      }

      Section("New Password") {
        TextField("Username", text: $username)
        PasswordField(text: $password)
        #if !os(macOS)
          .textContentType(.newPassword)
        #endif
      }
      
      Section("Custom Design") {
        TextField("Username", text: $username)
          .customTextFieldModifier()
        PasswordField(text: $password)
          .customTextFieldModifier()
      }
      
      Section("External Binding") {
        PasswordField(text: $password)
          .inputVisibile($isInputVisible)
          .visibilityControlPosition(.hidden)
        Toggle(isOn: $isInputVisible) {
          Text("Show Password")
        }
      }
      
      Section("Custom Control") {
        PasswordField(text: $password) { isInputVisible, action in
          Button(action: action) {
            Image(systemName: isInputVisible ? "eye.slash.circle.fill" : "eye.circle.fill")
          }
          .tint(.red)
          .buttonStyle(.borderless)
          .padding(4)
        }
        .visibilityControlPosition(.inlineOutside)
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
