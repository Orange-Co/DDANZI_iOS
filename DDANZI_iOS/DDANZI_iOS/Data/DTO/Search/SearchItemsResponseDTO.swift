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
