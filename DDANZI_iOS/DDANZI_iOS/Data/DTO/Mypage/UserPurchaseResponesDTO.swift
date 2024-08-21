//
//  UserPurchaseResponesDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - UserPurchaseResponesDTO
struct UserPurchaseResponesDTO: Codable {
  let totalCount: Int
  let orderProductList: [OrderProductList]
}

// MARK: - OrderProductList
struct OrderProductList: Codable {
  let productID: String
  let orderID: String
  let productName, imgURL: String
  let originPrice, salePrice: Int
  let paidAt: String
  
  enum CodingKeys: String, CodingKey {
    case productID = "productId"
    case orderID = "orderId"
    case productName
    case imgURL = "imgUrl"
    case originPrice, salePrice, paidAt
  }
}
