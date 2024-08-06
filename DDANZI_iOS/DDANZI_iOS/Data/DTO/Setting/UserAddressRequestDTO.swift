//
//  UserAddressRequestDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

struct UserAddressRequestDTO: Codable {
    var zipCode: String
    var type: AddressType
    var address: String
    var detailAddress: String
}

enum AddressType: String, Codable {
    case lot = "LOT"
    case road = "ROAD"
}
