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
  let name: String?
  let zipCode: String
  let type: AddressType
  let address, detailAddress, phone: String
  
  enum CodingKeys: String, CodingKey {
    case addressID = "addressId"
    case name, zipCode, type, address, detailAddress, phone
  }
}
