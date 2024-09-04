//
//  PaymentCompletedBody.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

/// payStatus : PAID / FAILED
struct PaymentCompletedBody: Codable {
  let orderId: String
  let payStatus: String
}
