//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Moiso on 23.01.23.
//

import SwiftUI

struct VisibilityButton: View {
  let action: () -> ()
  let isInputVisible: Bool
  
  var body: some View {
    Button(action: action) {
      Image(systemName: isInputVisible ? "eye.slash.fill" : "eye.fill")
    }
    .buttonStyle(.borderless)
    .padding(4)
  }
}
