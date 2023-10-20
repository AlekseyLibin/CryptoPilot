//
//  DetailView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 15.10.2023.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: CoinModel?
  
  var body: some View {
    ZStack {
      if let coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  @StateObject private var viewModel: DetailViewModel
  @State private var showFullDescription: Bool = false
  
  private let spacing: CGFloat = 30
  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  init(coin: CoinModel) {
    _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 20) {
        ChartView(coin: viewModel.coin)
          .padding(.vertical)
        
        VStack {
          overviewTitle
          Divider()
          descriptionSection
            .padding(.bottom)
          overviewGrid
          
          additionalTitle
          Divider()
          additionalGrid
            .padding(.bottom)
          Divider()
          links
        }
        .padding()
      }
    }
    .background(Color.theme.background.ignoresSafeArea())
    .navigationTitle(viewModel.coin.name)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        rightBarItem
      }
    }
  }
}

private extension DetailView {
  
  var overviewTitle: some View {
    Text("Overview")
      .font(.title)
      .bold()
      .foregroundStyle(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  var descriptionSection: some View {
    ZStack {
      if let coinDescription = viewModel.coinDescription,
         !coinDescription.isEmpty {
        VStack(alignment: .leading) {
          Text(coinDescription)
            .lineLimit(showFullDescription ? nil : 3)
            .font(.callout)
            .tint(Color.theme.secondaryText)
          
          Button(action: {
            showFullDescription.toggle()
          }, label: {
            Text(showFullDescription ? "Show less" : "more...")
          })
          .tint(.blue)
        }
      }
    }
  }
  
  var overviewGrid: some View {
    LazyVGrid(columns: columns,
              alignment: .leading,
              spacing: spacing,
              pinnedViews: [],
              content: {
      ForEach(viewModel.overviewStatistics) { stat in
        StatisticView(stat: stat)
      }
    })
  }
  
  var additionalTitle: some View {
    Text("Additional Details")
      .font(.title)
      .bold()
      .foregroundStyle(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  var additionalGrid: some View {
    LazyVGrid(columns: columns,
              alignment: .leading,
              spacing: spacing,
              pinnedViews: [],
              content: {
      ForEach(viewModel.additionalStatistics) { stat in
        StatisticView(stat: stat)
      }
    })
  }
  
  var links: some View {
    VStack(alignment: .leading, spacing: 10) {
      if let websiteString = viewModel.websiteURL,
         let websiteURL = URL(string: websiteString) {
        Link(destination: websiteURL) {
          Text(websiteString)
            .tint(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
        }
      }
      
      if let redditString = viewModel.redditURL,
         let redditURL = URL(string: redditString) {
        Link(destination: redditURL) {
          Text(redditString)
            .tint(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
        }
      }
    }
  }
  
  var rightBarItem: some View {
    HStack {
      Text(viewModel.coin.symbol.uppercased())
        .font(.headline)
        .foregroundStyle(Color.theme.secondaryText)
      CoinImageView(coin: viewModel.coin)
        .frame(width: 20, height: 20)
    }
  }
}

#Preview {
  NavigationView {
    DetailView(coin: DeveloperPreview.instance.coin)
  }
}
