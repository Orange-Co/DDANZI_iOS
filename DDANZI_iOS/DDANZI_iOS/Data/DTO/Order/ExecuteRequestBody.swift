//
//  ExecuteRequestBody.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

struct ExecuteRequestBody: Codable {
  let itemId: String
  let paymentId: String
  let selectedOptionDetailIdList: [Int]
}
