//
//  MarketDataService.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import Foundation
import Combine

final class MarketDataService {
  @Published var marketData: MarketDataModel? = nil
  var marketDataSubscription: AnyCancellable?
  
  init() {
    getData()
  }
  
  func getData() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/global?x_cg_demo_api_key=\(Keys.coniDeckoApiKey)") else { return }
    
    marketDataSubscription = NetworkingManager.download(url: url)
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
        self?.marketData = returnedGlobalData.data
        self?.marketDataSubscription?.cancel()
      })
  }
  
}
