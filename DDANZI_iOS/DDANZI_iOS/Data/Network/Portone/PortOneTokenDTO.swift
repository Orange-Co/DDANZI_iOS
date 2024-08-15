//
//  PortOneTokenRequestDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/15/24.
//

import Foundation


struct PortOneBaseResponse<T: Codable>: Codable {
  var code: Int?
  var message: String?
  var data: T?
  
  enum CodingKeys: String, CodingKey {
    case code
    case message
    case data = "response"
  }
}

struct PortoneAccessTokenRequestDTO: Codable {
    let impKey: String
    let impSecret: String
    
    enum CodingKeys: String, CodingKey {
        case impKey = "imp_key"
        case impSecret = "imp_secret"
    }
}

struct PortOneTokenResponseDTO: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct PortOneCertiResponseDTO: Codable {
  /// 포트원 인증 고유번호
  let impUid: String
  /// 본인인증 제공 PG사의 명칭
  let pgProvider: String
  /// 외국인 여부
  let foreigner: Bool
  
  /// 고객사 주문번호 (Optional)/
  let merchantUid: String?
  /// PG사 본인인증결과 고유번호 (Optional)/
  let pgTid: String?
  /// 인증된 사용자의 성명 (Optional)/
  let name: String?
  /// 인증된 사용자의 성별 (Optional)/
  let gender: String?
  /// 인증된 사용자의 생년월일 (Optional, ISO8601 형식, YYYY-MM-DD)/
  let birthday: String?
  /// 휴대폰번호 (Optional)/
  let phone: String?
  /// 통신사 (Optional)/
  let carrier: String?
  /// 본인인증 성공여부 (Optional)/
  let certified: Bool?
  /// 본인인증 처리시각 (Optional, UNIX timestamp)
  let certifiedAt: Int?
  /// 개인 고유구분 식별키 (Optional)/
  let uniqueKey: String?
  /// 고객사 내 개인 고유구분 식별키 (Optional)/
  let uniqueInSite: String?
  /// 본인인증 프로세스가 진행된 웹 페이지의 URL (Optional)/
  let origin: String?
  /// 외국인 여부(nullable) (Optional)/
  let foreignerV2: Bool?
  
  enum CodingKeys: String, CodingKey {
    case impUid = "imp_uid"
    case merchantUid = "merchant_uid"
    case pgTid = "pg_tid"
    case pgProvider = "pg_provider"
    case name
    case gender
    case birthday
    case foreigner
    case phone
    case carrier
    case certified
    case certifiedAt = "certified_at"
    case uniqueKey = "unique_key"
    case uniqueInSite = "unique_in_site"
    case origin
    case foreignerV2 = "foreigner_v2"
  }
}
