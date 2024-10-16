//
//  FetchOrderResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

// MARK: - FetchOrderResponseDTO
struct FetchOrderResponseDTO: Codable {
    let productId, productName, modifiedProductName: String
    let imgURL: String
    let originPrice: Int
    let addressInfo: AddressInfo
    let discountPrice, charge, totalPrice: Int

    enum CodingKeys: String, CodingKey {
        case productId, modifiedProductName
        case productName
        case imgURL = "imgUrl"
        case originPrice, addressInfo, discountPrice, charge, totalPrice
    }
}

// MARK: - AddressInfo
struct AddressInfo: Codable {
    let recipient, zipCode, address, recipientPhone: String?
}
