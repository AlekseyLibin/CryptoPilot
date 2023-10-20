//
//  SearchBarView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct SearchBarView: View {
  
  @Binding var searchText: String
  @FocusState private var isFocused: Bool
  
    var body: some View {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(
            searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
          )
        TextField("Search by name or symbol...", text: $searchText)
          .foregroundStyle(Color.theme.accent)
          .autocorrectionDisabled()
          .focused($isFocused)
          .onSubmit {
            isFocused = false
          }
          .overlay(alignment: .trailing, content: {
            Button {
              searchText = ""
              isFocused = false
            } label: {
              Image(systemName: searchText.isEmpty ? "chevron.down" : "xmark.circle.fill")
                .padding()
                .offset(x: 10)
                .opacity(isFocused ? 1.0 : 0.0)
                .foregroundStyle(Color.theme.accent)
            }

          })
      }
      .font(.headline)
      .padding(.all, 10)
      .background {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.theme.background)
          .shadow(color: Color.theme.accent.opacity(0.12),
                  radius: 10, x: 0.0, y: 0.0)
      }
    }
}

#Preview {
  SearchBarView(searchText: .constant(""))
}
