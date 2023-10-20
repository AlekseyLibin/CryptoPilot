//
//  HomeStatsView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct HomeStatsView: View {
  @EnvironmentObject private var viewModel: HomeViewModel
  @Binding var selectedScreen: HomeView.SelectedScreen
  
    var body: some View {
      HStack {
        ForEach(viewModel.statistics) { stat in
          StatisticView(stat: stat)
            .frame(width: UIScreen.main.bounds.width / 3)
        }
      }
      .frame(width: UIScreen.main.bounds.width, alignment: selectedScreen.allCoins ? .leading : .trailing)
      .animation(.spring)
    }
}

#Preview {
  HomeStatsView(selectedScreen: .constant(.allCoins))
    .environmentObject(DeveloperPreview.instance.homeViewModel)
}
