//
//  CoinImageService.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI
import Combine

final class CoinImageService {
  
  @Published var image: UIImage? = nil
  
  var imageSubscription: AnyCancellable?
  private let coin: CoinModel
  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"
  private let imageName: String
  
  init(coin: CoinModel) {
    self.coin = coin
    self.imageName = coin.id
    getCoinImage()
  }
  
  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName, folderName: folderName) {
      image = savedImage
    } else {
      downloadCoinImage()
    }
  }
  
  private func downloadCoinImage() {
    guard let url = URL(string: coin.image) else { return }
    imageSubscription = NetworkingManager.download(url: url)
      .tryMap({ UIImage(data: $0) })
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handleCompletion(_:), receiveValue: { [weak self] downloadedImage in
        guard let self = self, let downloadedImage = downloadedImage else { return }
        self.image = downloadedImage
        self.imageSubscription?.cancel()
        self.fileManager.saveImage(downloadedImage, imageName: imageName, folderName: folderName)
      })
  }
}
