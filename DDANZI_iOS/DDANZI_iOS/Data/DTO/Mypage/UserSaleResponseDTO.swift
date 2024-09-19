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
    let productID, itemID, productName: String
    let imgURL: String
    let originPrice, salePrice: Int
    let isInterested: Bool
    let interestCount: Int

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case itemID = "itemId"
        case productName
        case imgURL = "imgUrl"
        case originPrice, salePrice, isInterested, interestCount
    }
}
