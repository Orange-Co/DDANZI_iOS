//
//  ProductDetailResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - ProductDetailResponseDTO
struct ProductDetailResponseDTO: Codable {
    let name, category: String
    let isImminent: Bool
    let discountRate, stockCount: Int
    let infoURL: String
    let interestCount: Int

    enum CodingKeys: String, CodingKey {
        case name, category, isImminent, discountRate, stockCount
        case infoURL = "infoUrl"
        case interestCount
    }
}
