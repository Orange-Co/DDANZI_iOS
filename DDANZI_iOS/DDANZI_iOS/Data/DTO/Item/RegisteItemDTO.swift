//
//  RegisteItemDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

struct RegisteItemDTO: Codable {
  let itemId: String
  let productName: String
  let imgUrl: String
  let salePrice: Int
}
