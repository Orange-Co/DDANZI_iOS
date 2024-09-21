//
//  UserAccountRequestDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/21/24.
//

import Foundation

struct UserAccountRequestDTO: Codable {
  let acountName: String
  let bank: String
  let accountNumber: String
}
