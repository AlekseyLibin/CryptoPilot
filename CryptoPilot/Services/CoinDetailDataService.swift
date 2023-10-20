//
//  CoinDetailDataService.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 15.10.2023.
//

import Foundation
import Combine

final class CoinDetailDataService {
  @Published var coinDetails: CoinDetailModel? = nil
  private var coinDetailSubscription: AnyCancellable?
  private let coin: CoinModel
  
  init(_ coin: CoinModel) {
    self.coin = coin
    getCoins()
  }
  
  func getCoins() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false?x_cg_demo_api_key=\(Keys.coniDeckoApiKey)") else { print("a"); return }
    
    coinDetailSubscription = NetworkingManager.download(url: url)
      .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handleCompletion(_:), receiveValue: { [weak self] returnedCoinDetails in
        self?.coinDetails = returnedCoinDetails
        self?.coinDetailSubscription?.cancel()
        
      })
  }
}
