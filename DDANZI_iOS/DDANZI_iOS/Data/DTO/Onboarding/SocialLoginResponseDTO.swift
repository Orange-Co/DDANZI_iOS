//
//  SocialLoginResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation

// MARK: - SocialLoginResponseDTO
struct SocialLoginResponseDTO: Codable {
    let accesstoken, refreshtoken, nickname: String
}
