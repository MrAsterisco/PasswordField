//
//  VisibilityToggle.swift
//  
//
//  Created by Alessio Moiso on 23.01.23.
//

import SwiftUI

struct VisibilityToggle: View {
  @Binding var isInputVisible: Bool
  
  var body: some View {
    Toggle(isOn: $isInputVisible) {
      Text("Show Password")
    }
  }
}
