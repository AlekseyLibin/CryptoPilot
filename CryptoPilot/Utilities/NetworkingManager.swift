//
//  NetworkingManager.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import Foundation
import Combine

final class NetworkingManager {
  
  enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
      switch self {
      case .badURLResponse(url: let url): return "Bad URL response: \(url)"
      case .unknown: return "Unknown error occured"
      }
    }
  }
  
  static func download(url: URL) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { try handleURLResponse(output: $0, url: url) }
      .retry(3)
      .eraseToAnyPublisher()
  }
  
  static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
      throw NetworkingError.badURLResponse(url: url)
    }
    return output.data
  }
  
  static func handleCompletion(_ completion: Subscribers.Completion<Error>) {
    switch completion {
    case .finished: break
    case .failure(let error): print(error.localizedDescription)
    }
  }
}
