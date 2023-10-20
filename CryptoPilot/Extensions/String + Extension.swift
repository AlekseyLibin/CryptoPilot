//
//  String + Extension.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 16.10.2023.
//

import Foundation

extension String {
  var removingHTMLOccurances: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
}
