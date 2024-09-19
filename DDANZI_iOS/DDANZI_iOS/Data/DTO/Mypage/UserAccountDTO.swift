//
//  UserAccountDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/18/24.
//

import Foundation

// MARK: - UserAccountDTO
struct UserAccountDTO: Codable {
  let accountId: Int?
  let name: String
  let bank: String?
  let accountNumber: String?
}
