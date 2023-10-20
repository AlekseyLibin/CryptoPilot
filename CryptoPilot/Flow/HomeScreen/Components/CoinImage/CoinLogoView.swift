//
//  CoinLogoView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct CoinLogoView: View {
  
  let coin: CoinModel
  
    var body: some View {
      VStack {
        CoinImageView(coin: coin)
          .frame(width: 50, height: 50)
        Text(coin.symbol.uppercased())
          .font(.headline)
          .foregroundStyle(Color.theme.accent)
          .lineLimit(1)
          .minimumScaleFactor(0.5)
          .multilineTextAlignment(.center)
        Text(coin.name)
          .font(.caption)
          .foregroundStyle(Color.theme.secondaryText)
          .lineLimit(2)
          .minimumScaleFactor(0.5)
          .multilineTextAlignment(.center)
      }
    }
}

#Preview {
  CoinLogoView(coin: DeveloperPreview.instance.coin)
}
