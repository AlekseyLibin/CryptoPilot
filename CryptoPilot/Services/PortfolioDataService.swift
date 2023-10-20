//
//  PortfolioDataService.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 14.10.2023.
//

import Foundation
import CoreData

final class PortfolioDataService {
  private let container: NSPersistentContainer
  private var containerName: String = "PortfolioContainer"
  private let entityName: String = "PortfolioEntity"
  
  @Published var savedEntities: [PortfolioEntity] = []
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { _, error in
      if let error {
        print("Error loading Core Data:", error.localizedDescription)
      }
      self.getPortfolio()
    }
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
      if amount > 0 {
        update(entity, amount: amount)
      } else {
        delete(entity)
      }
    } else if amount > 0 {
      add(coin, amount: amount)
    }
  }
}

// MARK: - Private functionality
private extension PortfolioDataService {
  func getPortfolio() {
    let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
    do {
      savedEntities = try container.viewContext.fetch(request)
    } catch {
      print("Error fetching portfolio entities:", error.localizedDescription)
    }
  }
  
  func add(_ coin: CoinModel, amount: Double) {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    applyChanges()
  }
  
  func update(_ entity: PortfolioEntity, amount: Double) {
    entity.amount = amount
    applyChanges()
  }
  
  func delete(_ entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    applyChanges()
  }
  
  func save() {
    do {
      try container.viewContext.save()
    } catch {
      print("Error saving to Core Data:", error.localizedDescription)
    }
  }
  
  func applyChanges() {
    save()
    getPortfolio()
  }
}
