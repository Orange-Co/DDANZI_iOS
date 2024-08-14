//
//  SocialLoginRequestDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation

struct SocialLoginRequestDTO: Codable {
  let token: String
  let type: SocialLoginType
}

enum SocialLoginType: String,Codable {
  case apple = "APPLE"
  case kakao = "KAKAO"
}
