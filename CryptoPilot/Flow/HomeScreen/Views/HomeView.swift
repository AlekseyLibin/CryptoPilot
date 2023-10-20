//
//  HomeView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject private var viewModel: HomeViewModel
  @State private var isAnimating = false
  
  @State private var showInfoView: Bool = false
  @State private var showAddCoinsView: Bool = false
  
  @State private var selectedCoin: CoinModel? = nil
  @State private var showDetailView: Bool = false
  
  @State private var selectedScreen: SelectedScreen = .allCoins
    
  enum SelectedScreen: Int {
    case allCoins, portfolioCoins
    
    var allCoins: Bool { self == .allCoins }
    var portfolioCoins: Bool { self == .portfolioCoins }
    
    mutating func toggle() {
        self = (self == .allCoins) ? .portfolioCoins : .allCoins
    }
  }
  
  var body: some View {
    ZStack {
      Color.theme.background
        .ignoresSafeArea()
        .sheet(isPresented: $showAddCoinsView, content: {
          PortfolioView(showNewPortfolioView: $showAddCoinsView)
            .environmentObject(viewModel)
        })
        .sheet(isPresented: $showInfoView, content: {
          AppInformationView()
        })
      
      VStack {
        homeHeader
        HomeStatsView(selectedScreen: $selectedScreen)
        SearchBarView(searchText: $viewModel.searchText)
          .padding()
        columnTitles
        TabView(selection: $selectedScreen) {
           allCoinsList
            .tag(SelectedScreen.allCoins)
          if viewModel.portfolioCoins.isEmpty,
             viewModel.searchText.isEmpty {
             emptyPortfolioView
              .tag(SelectedScreen.portfolioCoins)
          } else {
             portfolioCoinsList
              .tag(SelectedScreen.portfolioCoins)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .ignoresSafeArea()
      }
    }
    .background {
      NavigationLink(destination: DetailLoadingView(coin: $selectedCoin),
                     isActive: $showDetailView,
                     label: { EmptyView() })
    }
  }
}

#Preview {
  NavigationView {
    HomeView()
      .toolbar(.hidden)
  }
  .environmentObject(DeveloperPreview.instance.homeViewModel)
}

private extension HomeView {
  var homeHeader: some View {
    HStack {
      CircleButtonView(iconSystemName: selectedScreen.allCoins ? "info" : "plus") {
        selectedScreen.allCoins ? showInfoView.toggle() : showAddCoinsView.toggle()
      }
      .animation(.none)
      Spacer()
      Text(selectedScreen.allCoins ? "Portfolio" : "Live Prices")
        .fontWeight(.heavy)
        .foregroundStyle(Color.theme.accent)
        .animation(.none)
      Spacer()
      CircleButtonView(iconSystemName: "chevron.right") {
        withAnimation {
          selectedScreen.toggle()
        }
      }
      .rotationEffect(Angle(degrees: selectedScreen.portfolioCoins ? 180 : 0))
      .animation(.spring)
    }
  }
  
  var allCoinsList: some View {
    List {
      ForEach(viewModel.allCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: false)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
          .onTapGesture {
            segue(coin: coin)
          }
          .listRowBackground(Color.theme.background)
      }
    }
    
    .listStyle(PlainListStyle())
    .transition(.move(edge: .leading))
    .refreshable {
      viewModel.reloadData()
    }
  }
  
  var portfolioCoinsList: some View {
    List {
      ForEach(viewModel.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
          .onTapGesture {
            segue(coin: coin)
          }
          .listRowBackground(Color.theme.background)
      }
      .onDelete(perform: { indexSet in
        viewModel.deletePortfolioCoins(by: indexSet)
      })
    }
    .listStyle(PlainListStyle())
        .transition(.move(edge: .trailing))
    .refreshable {
      viewModel.reloadData()
    }
  }
  
  var emptyPortfolioView: some View {
    VStack {
      Text("It looks like you have added no coins to your portfolio. Now is the perfect time to do so! Click the ➕ button to get started!")
        .font(.callout)
        .foregroundStyle(Color.theme.accent)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .padding(50)
        .background {
          RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.gray.opacity(0.15))
            .padding(20)
        }
        .padding(.top, 50)
      Spacer()
    }
    //    .transition(.move(edge: .trailing))
  }
  
  func segue(coin: CoinModel) {
    selectedCoin = coin
    showDetailView.toggle()
  }
  
  var columnTitles: some View {
    HStack {
      HStack {
        Text("Coin")
        Image(systemName: "chevron.down")
          .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
          .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
        }
      }
      Spacer()
      if selectedScreen.portfolioCoins {
        HStack {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
            .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
        }
        .onTapGesture {
          withAnimation(.default) {
            viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
          }
        }
      }
      HStack {
        Text("Price")
        Image(systemName: "chevron.down")
          .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
          .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
        }
      }
      .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
      Button {
        withAnimation(.linear(duration: 2.0)) {
          viewModel.reloadData()
        }
      } label: {
        Image(systemName: "goforward")
      }
      .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)
      
    }
    .font(.caption)
    .foregroundStyle(Color.theme.secondaryText)
    .padding(.horizontal)
  }
}
