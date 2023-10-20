//
//  CoinDataService.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import Foundation
import Combine

final class CoinDataService {
  @Published var allCoins: [CoinModel] = []
  private var coinSubscription: AnyCancellable?
  
  init() {
    getCoins()
  }
  
  func getCoins() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h?x_cg_demo_api_key=\(Keys.coniDeckoApiKey)&locale=en") else { return }
    
    coinSubscription = NetworkingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handleCompletion(_:), receiveValue: { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
        self?.coinSubscription?.cancel()
        
      })
  }
}
