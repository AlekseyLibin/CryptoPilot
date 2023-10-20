//
//  PortfolioView.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import SwiftUI

struct PortfolioView: View {
  
  @EnvironmentObject private var viewModel: HomeViewModel
  @Binding var showNewPortfolioView: Bool
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantityText: String = ""
  @State private var showCheckmark: Bool = false
  @State private var scrollPosition: CGFloat = 0.0
  @FocusState private var isFocused: Bool
  
    var body: some View {
      NavigationView {
        ScrollView {
          VStack(alignment: .leading, spacing: 15) {
            SearchBarView(searchText: $viewModel.searchText)
              .padding(.horizontal)
            coinLogoHorizontalList
            if selectedCoin != nil {
              portfolioInputSection
            }
          }
        }
        .background(Color.theme.background)
        .onTapGesture {
          isFocused = false
        }
        .navigationTitle("Edit Portfolio")
        .toolbar(content: {
          ToolbarItem(placement: .topBarLeading) { XMarkButton() }
          ToolbarItem(placement: .topBarTrailing) {
            trailingToolBarButton
          }
        })
        .onChange(of: viewModel.searchText, perform: { value in
          if value.isEmpty {
            removeSelectedCoin()
          }
        })
      }
    }
}

extension PortfolioView {
  private var coinLogoHorizontalList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 10) {
        ForEach(horizontalListContent) { coin in
          CoinLogoView(coin: coin)
            .frame(width: 70)
            .padding(4)
            .onTapGesture {
                withAnimation {
                  updateSelectedCoin(coin)
                  isFocused = true
                }
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(selectedCoin?.id == coin.id ? Color.indigo : Color.clear, lineWidth: 1)
            )
        }
      }
      .padding(.vertical, 4)
      .padding(.leading)
    }
  }
  
  private var horizontalListContent: [CoinModel] {
    viewModel.allCoins.sorted { first, second in
      return viewModel.portfolioCoins.contains(where: { $0.id == first.id }) ? true : false
    }
  }
  
  private var portfolioInputSection: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
        Spacer()
        Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
      }
      Divider()
      HStack {
        Text("Amount holding:")
        Spacer()
        TextField("Ex: 1.4", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .focused($isFocused)
          .onAppear {
            print("1")
            isFocused = true
          }
          
      }
      Divider()
      HStack {
        Text("Current value:")
        Spacer()
        Text(getCurrentValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none)
    .padding()
    .font(.headline)
  }
  
  private var trailingToolBarButton: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckmark ? 1.0 : 0.0)
      Button(action: {
        saveButtonPressed()
      }, label: {
        Text("Save".uppercased())
      })
      .opacity(saveButtonShouldBeActive ? 1.0 : 0.0 )
    }
    .font(.headline)
  }
  
  private var saveButtonShouldBeActive: Bool {
    if let selectedCoin,
       let selectedQuantity = Double(quantityText) {
      if let currentHoldings = selectedCoin.currentHoldings,
         currentHoldings > 0,
         selectedQuantity == 0 {
        return true
      } else if selectedCoin.currentHoldings == nil,
                selectedQuantity > 0 {
        return true
      } else { return false }
    } else { return false }
  }
  
  private func saveButtonPressed() {
    guard
      let coin = selectedCoin,
      let amount = Double(quantityText)
    else { return }
    
    // save to portfolio
    viewModel.updatePortfolio(coin: coin, amount: amount)
    
    // show the checkmark
    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
      
    // hide keyboard
      isFocused = false
      
      // hide checkmark
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation(.easeOut) {
          showCheckmark = false
          showNewPortfolioView = false
        }
      }
    }
  }
  
  private func removeSelectedCoin() {
    selectedCoin = nil
    viewModel.searchText = ""
  }
  
  private func updateSelectedCoin(_ coin: CoinModel) {
    selectedCoin = coin
    
    // update actual amount value
    if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
       let amount = portfolioCoin.currentHoldings {
      quantityText = amount.description
    } else {
      quantityText = ""
    }
  }
  
  private func getCurrentValue() -> Double {
    if let quantity = Double(quantityText) {
      return quantity * (selectedCoin?.currentPrice ?? 0)
    } else { return 0 }
    
  }
}

#Preview {
  PortfolioView(showNewPortfolioView: .constant(true))
    .environmentObject(DeveloperPreview.instance.homeViewModel)
}
