//
//  HomeItemsResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - HomeItemsResponseDTO
struct HomeItemsResponseDTO: Codable {
  let homeImgURL: String
  let productList: [ProductList]
  let pageInfo: PageInfo
  
  enum CodingKeys: String, CodingKey {
    case homeImgURL = "homeImgUrl"
    case productList
    case pageInfo
  }
}

// MARK: - ProductList
struct ProductList: Codable {
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
    case originPrice, salePrice, interestCount
    case isInterested
  }
}

struct PageInfo: Codable {
  let totalElements: Int
  let numberOfElements: Int
}
