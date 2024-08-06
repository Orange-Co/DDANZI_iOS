//
//  InterestResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/7/24.
//

import Foundation

/// 관심 등록 삭제에 모두 사용됩니다.
struct InterestResponseDTO: Codable {
  var nickname: String
  var productId: Int
}
