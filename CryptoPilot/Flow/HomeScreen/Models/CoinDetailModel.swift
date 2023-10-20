//
//  CoinDetailModel.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 15.10.2023.
//

import Foundation

struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let description: Description?
    let links: Links?
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurances
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
