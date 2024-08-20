//
//  PaymentCompletedBody.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

struct PaymentCompletedBody: Codable {
  let paymentId: String
  let payStatus: String
}
