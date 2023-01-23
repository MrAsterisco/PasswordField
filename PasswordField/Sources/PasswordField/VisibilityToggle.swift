//
//  VisibilityToggle.swift
//  
//
//  Created by Alessio Moiso on 23.01.23.
//

import SwiftUI

struct VisibilityToggle: View {
  @State private var isOn = false
  
  let action: () -> ()
  let isInputVisible: Bool
  
  var body: some View {
    Toggle(isOn: $isOn) {
      Text("Show Password")
    }
    .onChange(of: isOn) { newValue in
      action()
    }
    .onAppear {
      isOn = isInputVisible
    }
  }
}
