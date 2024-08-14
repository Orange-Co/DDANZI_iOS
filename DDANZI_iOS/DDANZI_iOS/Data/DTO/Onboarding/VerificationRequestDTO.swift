//
//  VerificationRequestDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation

struct VerificationRequestDTO: Codable {
  let name, phone: String
  let brith: String /// YYYY.MM,DD
  let sex: String /// M/F
}
