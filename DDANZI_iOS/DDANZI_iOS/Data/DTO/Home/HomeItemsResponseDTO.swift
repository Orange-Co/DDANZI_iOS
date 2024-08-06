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

    enum CodingKeys: String, CodingKey {
        case homeImgURL = "homeImgUrl"
        case productList
    }
}

// MARK: - ProductList
struct ProductList: Codable {
    let productID: Int
    let kakaoProductID: Int?
    let name, imgURL: String
    let originPrice, salePrice, interestCount: Int

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case kakaoProductID = "kakaoProductId"
        case name
        case imgURL = "imgUrl"
        case originPrice, salePrice, interestCount
    }
}
