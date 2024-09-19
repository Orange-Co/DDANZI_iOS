//
//  VerificationRequestDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation

struct VerificationRequestDTO: Codable {
  let name, phone: String
  let birth: String /// YYYY-MM-DD
  let sex: String /// FEMALE/MALE
  let isAgreedMarketingTerm: Bool
  let ci: String
}
