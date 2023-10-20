//
//  LaunchView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 17.10.2023.
//

import SwiftUI

struct LaunchView: View {
  
  
  @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
  @State private var showLoadingText: Bool = false
  @State private var counter: Int = 0
  @Binding var showLaunchView: Bool
  private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
    var body: some View {
      ZStack {
        Color.theme.background
          .ignoresSafeArea()
        
        Image("logoTransparent")
          .resizable()
          .frame(width: 200, height: 200)
        
        ZStack {
          if showLoadingText {
            HStack(spacing: 0) {
              ForEach(loadingText.indices) { index in
                Text(loadingText[index])
                  .font(.headline)
                  .fontWeight(.heavy)
                  .foregroundStyle(Color.theme.accent)
                  .offset(y: counter == index + 1 ? -8 : 0)
                
              }
            }
            .transition(AnyTransition.scale.animation(.easeIn))
          }
        }
        .offset(y: 100)
      }
      .onAppear {
        showLoadingText.toggle()
      }
      .onReceive(timer, perform: { _ in
        withAnimation(.spring) {
          
          let lastIndex = loadingText.count
          if counter == lastIndex {
            showLaunchView = false
          } else {
            counter += 1
          }
        }
      })
    }
}

#Preview {
  LaunchView(showLaunchView: .constant(true))
}
