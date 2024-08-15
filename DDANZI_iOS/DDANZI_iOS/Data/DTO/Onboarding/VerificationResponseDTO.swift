//
//  VerificationResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation

// MARK: - VerificationResponseDTO
struct VerificationResponseDTO: Codable {
  let accesstoken, refreshtoken, name: String
}
