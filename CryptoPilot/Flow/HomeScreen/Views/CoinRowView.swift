//
//  CoinRowView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct CoinRowView: View {
  
  let coin: CoinModel
  let showHoldingsColumn: Bool
  
    var body: some View {
      HStack(spacing: 0) {
        leftColumn
        Spacer()
        if showHoldingsColumn {
          centerCulomn
        }
        rightCulumn
      }
      .font(.subheadline)
      .background(Color.theme.background.opacity(0.001))
    }
}

extension CoinRowView {
  private var leftColumn: some View {
    HStack(spacing: 0) {
      Text("\(coin.rank)")
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .frame(minWidth: 30)
      CoinImageView(coin: coin)
        .frame(width: 30, height: 30)
      Text(coin.symbol.uppercased())
        .font(.headline)
        .padding(.leading, 6)
        .foregroundStyle(Color.theme.accent)
    }
  }
  
  private var centerCulomn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue.asCurrencyWith2Decimals()).bold()
      Text((coin.currentHoldings ?? 0).asNumberString())
    }
    .foregroundStyle(Color.theme.accent)
  }
  
  private var rightCulumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentPrice.asCurrencyWith6Decimals())
        .bold()
        .foregroundStyle(Color.theme.accent)
      Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
        .font(.caption)
        .foregroundStyle(
          (coin.priceChangePercentage24H ?? 0) >= 0 ?
          Color.theme.green : Color.theme.red
        )
    }
    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
  }
}

#Preview {
  CoinRowView(coin: DeveloperPreview.instance.coin, showHoldingsColumn: true)
}
