//
//  UserAddressResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

// MARK: - UserAddressResponseDTO
struct UserAddressResponseDTO: Codable {
  let addressID: Int?
  let recipient: String?
  let zipCode: String
  let type: AddressType
  let address, detailAddress, recipientPhone: String
  
  enum CodingKeys: String, CodingKey {
    case addressID = "addressId"
    case recipient, zipCode, type, address, detailAddress, recipientPhone
  }
}
