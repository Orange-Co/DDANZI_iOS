//
//  PaymentCompletedDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

struct PaymentCompletedDTO: Codable {
  let paymentId: String
  let payStatus: String
  let endedAt: String
}
