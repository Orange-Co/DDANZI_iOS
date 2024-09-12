//
//  itemConfirmedDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

struct itemConformedDTO: Codable {
  let productId: String
  let productName: String
  let originPrice: Int
  let salePrice: Int
  let isAccounExist: Bool
  let imgUrl: String
}
