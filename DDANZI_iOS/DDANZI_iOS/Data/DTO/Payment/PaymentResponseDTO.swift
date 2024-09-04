//
//  PaymentResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

struct PaymentResponseDTO: Codable {
  let orderId: String
  let paymentId: String
  let payStatus: String
  let startedAt: String
}
