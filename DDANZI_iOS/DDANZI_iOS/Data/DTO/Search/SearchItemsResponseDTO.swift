//
//  SearchItemsResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - SearchItemsResponseDTO
struct SearchItemsResponseDTO: Codable {
  let topSearchedList: [String]
  let recentlyViewedList: [RecentlyViewedList]
}

// MARK: - RecentlyViewedList
struct RecentlyViewedList: Codable {
  let productID: String
  let kakaoProductID: Int
  let name: String
  let imgURL: String
  let originPrice, salePrice, interestCount: Int
  let isInterested: Bool
  
  enum CodingKeys: String, CodingKey {
    case productID = "productId"
    case kakaoProductID = "kakaoProductId"
    case name
    case imgURL = "imgUrl"
    case originPrice, salePrice, interestCount, isInterested
  }
}
