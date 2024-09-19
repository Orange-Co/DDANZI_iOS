//
//  ConformedDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import Foundation

// MARK: - ConformedDTO
struct ConformedDTO: Codable {
    let orderID, orderStatus: String

    enum CodingKeys: String, CodingKey {
        case orderID = "orderId"
        case orderStatus
    }
}
