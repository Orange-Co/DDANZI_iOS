//
//  PaymentResponseBody.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

struct PaymentRequestBody: Codable {
  let itemId: Int
  let charge: Int
  let totalPrice: Int
  let method: String
}
