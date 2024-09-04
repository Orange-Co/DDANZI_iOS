//
//  PaymentStartResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/4/24.
//

import Foundation

// MARK: - PaymentStartResponseDTO
struct PaymentStartResponseDTO: Codable {
    let orderID, payStatus, startedAt: String

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case payStatus, startedAt
    }
}
