//
//  ProductDetailResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - HomeItemsResponseDTO
struct ProductDetailResponseDTO: Codable {
    let name: String
    let imgURL: String
    let category: String
    let isOptionExist, isImminent: Bool
    let discountRate, originPrice, salePrice, stockCount: Int
    let infoURL: String
    let interestCount: Int
    let optionList: [OptionList]

    enum CodingKeys: String, CodingKey {
        case name
        case imgURL = "imgUrl"
        case category, isOptionExist, isImminent, discountRate, originPrice, salePrice, stockCount
        case infoURL = "infoUrl"
        case interestCount, optionList
    }
}

// MARK: - OptionList
struct OptionList: Codable {
    let optionID: Int
    let type: String
    let optionDetailList: [OptionDetailList]

    enum CodingKeys: String, CodingKey {
        case optionID = "optionId"
        case type, optionDetailList
    }
}

// MARK: - OptionDetailList
struct OptionDetailList: Codable {
    let optionDetailID: Int
    let content: String
    let isAvailable: Bool

    enum CodingKeys: String, CodingKey {
        case optionDetailID = "optionDetailId"
        case content, isAvailable
    }
}
