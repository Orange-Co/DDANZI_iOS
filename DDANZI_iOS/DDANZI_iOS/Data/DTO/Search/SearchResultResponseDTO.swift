//
//  SearchResultResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - SearchResultResponseDTO
struct SearchResultResponseDTO: Codable {
    let searchedProductList: [SearchedProductList]
}

// MARK: - SearchedProductList
struct SearchedProductList: Codable {
    let productID: Int
    let name, imgURL: String
    let originPrice, salePrice, interestCount: Int

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case name
        case imgURL = "imgUrl"
        case originPrice, salePrice, interestCount
    }
}
