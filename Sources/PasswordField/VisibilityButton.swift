//
//  SwiftUIView.swift
//  
//
//  Created by Alessio Moiso on 23.01.23.
//

import SwiftUI

struct VisibilityButton: View {
  @Binding var isInputVisible: Bool
  
  var body: some View {
    Button(action: {
      isInputVisible.toggle()
    }) {
      Image(systemName: isInputVisible ? "eye.slash.fill" : "eye.fill")
    }
    #if !os(tvOS)
    .buttonStyle(.borderless)
    #endif
    .padding(4)
  }
}
