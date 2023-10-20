//
//  HomeViewModel.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
  
  @Published var statistics = [StatisticModel]()
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  @Published var isLoading: Bool = false
  @Published var searchText: String = ""
  @Published var sortOption: SortOption = .holdings
  
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()
  private var cancellables = Set<AnyCancellable>()
  
  /// Sorting option for the list of Coins
  enum SortOption {
    case rank, rankReversed
    case holdings, holdingsReversed
    case price, priceReversed
  }
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    coinDataService.$allCoins
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
    
    // updates all coins
    $searchText
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .map(filterAndSortCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
    
    // updates portfolioCoins
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] returnedCoins in
        self?.portfolioCoins = self?.sort(portfolioCoins: returnedCoins) ?? returnedCoins
      }
      .store(in: &cancellables)
    
    // updates marketData
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapGlobalMarketData)
      .sink { [weak self] returnedStats in
        self?.statistics = returnedStats
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
  
  func deletePortfolioCoins(by indexSet: IndexSet) {
    indexSet.forEach { 
      portfolioDataService.updatePortfolio(coin: portfolioCoins[$0], amount: 0)
    }
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    coinDataService.getCoins()
    marketDataService.getData()
  }
  
  private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption) -> [CoinModel] {
    var updatedCoins = filter(coins: coins, by: text)
    sort(coins: &updatedCoins, by: sortOption)
    return updatedCoins
  }
  
  private func filter(coins: [CoinModel], by text: String) -> [CoinModel] {
    guard !text.isEmpty else { return  coins }
    let lowercasedText = text.lowercased()
    return coins.filter { (coin) -> Bool in
      return  coin.name.lowercased().contains(lowercasedText) ||
              coin.symbol.lowercased().contains(lowercasedText) ||
              coin.id.lowercased().contains(lowercasedText)
    }
  }
  
  private func sort(coins: inout [CoinModel], by sortOption: SortOption) {
    switch sortOption {
    case .rank, .holdings:
      coins.sort(by: { $0.rank < $1.rank })
    case .rankReversed, .holdingsReversed:
      coins.sort(by: { $0.rank > $1.rank })
    case .price: 
      coins.sort(by: { $0.currentPrice > $1.currentPrice })
    case .priceReversed: 
      coins.sort(by: { $0.currentPrice < $1.currentPrice })
    }
  }
  
  private func sort(portfolioCoins: [CoinModel]) -> [CoinModel] {
    
    // will only sort by .holdings or .reversedHoldings if needed
    switch sortOption {
    case .holdings:
      return portfolioCoins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
    case .holdingsReversed:
      return portfolioCoins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
    default:
      return portfolioCoins
    }
  }
  
  private func mapAllCoinsToPortfolioCoins(_ allCoins: [CoinModel], _ portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
    allCoins
        .compactMap { (coin) -> CoinModel? in
          guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else { return nil }
          return coin.updateHoldings(amount: entity.amount)
        }
  }
  
  private func mapGlobalMarketData(_ data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
    var stats = [StatisticModel]()
    
    guard let data = data else  { return stats }
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "24h Volume", value: data.volume)
    let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    
    
    let portfolioValue = portfolioCoins
      .map { $0.currentHoldingsValue }
      .reduce(0, +)
    
    let previousValue = portfolioCoins
      .map { (coin) -> Double in
        let currentValue = coin.currentHoldingsValue
        let percentChange = coin.priceChangePercentage24H ?? 0 / 100
        let previousValue = currentValue / (1 + percentChange)
        return previousValue
      }
      .reduce(0, +)
    
    let percentageChange = previousValue == 0 ? nil : ((portfolioValue - previousValue) / previousValue)
        
    let portfolio = StatisticModel(title: "Portfolio Value",
                                   value: portfolioValue.asCurrencyWith2Decimals(),
                                   percentageChange: percentageChange)
    
    stats.append(contentsOf: [
      marketCap,
      volume,
      btcDominance,
      portfolio
    ])
    return stats
  }
}
