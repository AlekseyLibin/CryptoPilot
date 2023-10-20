//
//  CryptoPilotApp.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

@main
struct CryptoPilotApp: App {
  
  @StateObject private var viewModel = HomeViewModel()
  @State private var showLaunchView: Bool = true
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
    UITableView.appearance().backgroundColor = UIColor.clear
  }
  
    var body: some Scene {
        WindowGroup {
          ZStack {
            NavigationView {
              HomeView()
                .toolbar(.hidden)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(viewModel)
            
            ZStack {
              if showLaunchView {
                LaunchView(showLaunchView: $showLaunchView)
                  .transition(.move(edge: .leading))
              }
            }
            .zIndex(2)
          }
        }
    }
}
