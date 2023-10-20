//
//  XMarkButton.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct XMarkButton: View {
  
  @Environment(\.presentationMode) var presentationMode
  
    var body: some View {
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }, label: {
        Image(systemName: "xmark")
          .font(.headline)
      })
    }
}

#Preview {
    XMarkButton()
}
