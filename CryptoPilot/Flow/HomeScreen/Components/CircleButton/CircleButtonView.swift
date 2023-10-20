//
//  CircleButtonVuew.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct CircleButtonView: View {
  
  let iconSystemName: String
  let action: () -> Void
  
    var body: some View {
      Button(action: action, label: {
        Image(systemName: iconSystemName)
        .font(.headline)
        .foregroundStyle(Color.theme.accent)
        .frame(width: 50, height: 50, alignment: .center)
        .background {
          Circle()
            .foregroundStyle(Color.theme.background)
        }
        .shadow(color: Color.theme.accent.opacity(0.15),
                radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
        .padding()
      })
    }
}

#Preview {
  CircleButtonView(iconSystemName: "heart.fill", action: {})
  .previewLayout(.sizeThatFits)
}
