//
//  InterestEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum InterestEndpoint {
  case addInterest(String)
  case deleteInterest(String)
}

extension InterestEndpoint: BaseTargetType {
    var headers: Parameters? {
      switch self {
      case .addInterest:
        return APIConstants.hasAccessTokenHeader
      case .deleteInterest:
        return APIConstants.hasAccessTokenHeader
      }
    }
    
    var path: String {
      switch self {
      case let .addInterest(id):
        return "/api/v1/interest/\(id)"
      case let .deleteInterest(id):
        return "/api/v1/interest/\(id)"
      }
    }
    
    var method: Moya.Method {
      switch self {
      case .addInterest:
        return .post
      case .deleteInterest:
        return .delete
      }
    }
    
    var task: Moya.Task {
      switch self {
      case .addInterest:
        return .requestPlain
      case .deleteInterest:
        return .requestPlain
      }
    }
    
    var validationType: ValidationType {
      switch self {
      case .addInterest:
        return .successCodes
      case .deleteInterest:
        return .successCodes
      }
    }
}
