//
//  SellDetailDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

// MARK: - SellDetailDTO
struct SellDetailDTO: Codable {
    let itemID: String
    let imgURL: String
    let status, productName: String
    let originPrice, salePrice: Int
    let orderID, buyerNickName: String?
    let addressInfo: AddressInfo
    let paidAt, paymentMethod: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case imgURL = "imgUrl"
        case status, productName, originPrice, salePrice
        case orderID = "orderId"
        case buyerNickName, addressInfo, paidAt, paymentMethod
    }
}
