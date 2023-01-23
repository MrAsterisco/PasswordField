//
//  CustomTextFieldModifier.swift
//  PasswordFieldExample
//
//  Created by Alessio Moiso on 23.01.23.
//

import SwiftUI

struct CustomTextFieldModifier: ViewModifier {
  @FocusState private var isFocused: Bool
  
  func body(content: Content) -> some View {
    content
      .padding()
      .background(isFocused ? .red : .white)
      .cornerRadius(8)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(isFocused ? .red : .black, lineWidth: 1)
      }
      .focused($isFocused)
  }
}

extension View {
  func customTextFieldModifier() -> some View {
    modifier(CustomTextFieldModifier())
  }
}
