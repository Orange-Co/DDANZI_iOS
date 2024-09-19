//
//  RefreshTokenDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/18/24.
//

import Foundation

// MARK: - RefreshTokenDTO
struct RefreshTokenDTO: Codable {
  let accesstoken: String?
  let refreshtoken: String
}
