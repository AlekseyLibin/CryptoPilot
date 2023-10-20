//
//  DetailViewModel.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 15.10.2023.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
  @Published var overviewStatistics: [StatisticModel] = []
  @Published var additionalStatistics: [StatisticModel] = []
  @Published var coinDescription: String? = nil
  @Published var websiteURL: String? = nil
  @Published var redditURL: String? = nil
  @Published var coin: CoinModel
  
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailService = CoinDetailDataService(coin)
    addSubscribers()
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map(mapDataToStatistics)
      .sink { [weak self] returnedArrays in
        self?.overviewStatistics = returnedArrays.overview
        self?.additionalStatistics = returnedArrays.additional
      }
      .store(in: &cancellables)
    
    coinDetailService.$coinDetails
      .sink { [weak self] returnedCoinDetails in
        self?.coinDescription = returnedCoinDetails?.description?.en?.removingHTMLOccurances
        self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
        self?.redditURL = returnedCoinDetails?.links?.subredditURL
      }
      .store(in: &cancellables)
  }
  
  private func mapDataToStatistics(_ coinDetail: CoinDetailModel?, _ coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
     
    let overviewArray = createOverviewArray(coinDetail, coin)
    let additionalArray = createAdditionalArray(coinDetail, coin)
     
     return (overviewArray, additionalArray)
  }
  
  private func createOverviewArray(_ coinDetail: CoinDetailModel?, _ coin: CoinModel) -> [StatisticModel] {
    let price = coin.currentPrice.asCurrencyWith6Decimals()
    let pricePercentageChange = coin.priceChangePercentage24H
    let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
    
    let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
    let marketCapPercentageChange = coin.marketCapChangePercentage24H
    let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)
    
    let rank = coin.rank.description
    let rankStat = StatisticModel(title: "Rank", value: rank)
    
    let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
    let volumeStat = StatisticModel(title: "Volume", value: volume)
    
    let overviewArray: [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
    return overviewArray
  }
  
  private func createAdditionalArray(_ coinDetail: CoinDetailModel?, _ coin: CoinModel) -> [StatisticModel] {
    let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let highStat = StatisticModel(title: "24h High", value: high)
    
    let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let lowStat = StatisticModel(title: "24h Low", value: low)
    
    let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
    let pricePercentageChange = coin.priceChangePercentage24H
    let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange)
    
    let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
    let marketCapPercentageChange = coin.marketCapChangePercentage24H
    let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange)
    
    let additionalArray: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapChangeStat]
    return additionalArray
  }
}
