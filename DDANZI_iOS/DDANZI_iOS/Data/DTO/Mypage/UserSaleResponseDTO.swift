//
//  UserSaleResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - UserSaleResponseDTO
struct UserSaleResponseDTO: Codable {
    let totalCount: Int
    let itemProductList: [ItemProductList]
}

// MARK: - ItemProductList
struct ItemProductList: Codable {
    let productID: Int
    let name, imgURL: String
    let originPrice, salePrice: Int
    let completedAt: String
    let interestCount: Int

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case name
        case imgURL = "imgUrl"
        case originPrice, salePrice, completedAt, interestCount
    }
}
