//
//  UserInterestResponesDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - UserInterestResponesDTO
struct UserInterestResponesDTO: Codable {
    let totalCount: Int
    let productList: [InterestItem]
}

// MARK: - ProductList
struct InterestItem: Codable {
    let productID: String
    let name, imgURL: String
    let originPrice, salePrice, interestCount: Int

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case name
        case imgURL = "imgUrl"
        case originPrice, salePrice, interestCount
    }
}
