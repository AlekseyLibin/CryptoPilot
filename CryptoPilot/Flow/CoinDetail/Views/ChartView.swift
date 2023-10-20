//
//  ChartView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 15.10.2023.
//

import SwiftUI

struct ChartView: View {
  
  private let data: [Double]
  private let maxY: Double
  private let minY: Double
  private let lineColor: Color
  private let startingDate: Date
  private let endingDate: Date
  @State private var percentage: CGFloat = 0
  
  init(coin: CoinModel) {
    data = coin.sparklineIn7D?.price ?? []
    maxY = data.max() ?? 0
    minY = data.min() ?? 0
    
    let priceChange = (data.last ?? 0) - (data.first ?? 0)
    lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    
    endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
    startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
  }
  
    var body: some View {
      VStack {
        chartView
          .frame(height: 200)
          .background(chartBackground)
          .overlay(alignment: .leading, content: { chartYAxis.padding(.horizontal, 5) })
        chartDateLabels
          .padding(.horizontal, 5)
      }
      .font(.caption)
      .foregroundStyle(Color.theme.secondaryText)
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          withAnimation(.linear(duration: 2)) {
            percentage = 1.0
          }
        }
      }
    }
}

private extension ChartView {
  var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        for index in data.indices {
          let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
          let yAxis = maxY-minY
          let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
          
          if index == 0 {
            path.move(to: CGPoint(x: 0, y: 0))
          }
          path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
      }
      .trim(from: 0, to: percentage)
      .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor, radius: 30, x: 0, y: 10)
      .shadow(color: lineColor, radius: 40, x: 0, y: 10)
      .shadow(color: lineColor, radius: 50, x: 0, y: 10)
    }
  }
  
  var chartBackground: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }
  
  var chartYAxis: some View {
    VStack {
      Text(maxY.formattedWithAbbreviations())
      Spacer()
      Text(((maxY + minY) / 2).formattedWithAbbreviations())
      Spacer()
      Text(minY.formattedWithAbbreviations())
    }
  }
  
  var chartDateLabels: some View {
    HStack {
      Text(startingDate.asShortDateString())
      Spacer()
      Text(endingDate.asShortDateString())
    }
  }
}

#Preview {
  ChartView(coin: DeveloperPreview.instance.coin)
}
