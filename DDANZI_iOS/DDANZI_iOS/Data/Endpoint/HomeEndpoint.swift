//
//  HomeEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum HomeEndpoint {
    case loadHomeItems
    case loadItemsDetail(String)
}

extension HomeEndpoint: BaseTargetType {
    var headers: Parameters? {
      switch self {
      case .loadHomeItems:
        return APIConstants.hasAccessTokenHeader
      case .loadItemsDetail:
        return APIConstants.hasNickname
      }
    }
    
    var path: String {
      switch self {
      case .loadHomeItems:
        return "/api/v1/home"
      case let .loadItemsDetail(id):
        return "/api/v1/home/product/\(id)"
      }
    }
    
    var method: Moya.Method {
      switch self {
      case .loadHomeItems:
        return .get
      case .loadItemsDetail:
        return .get
      }
    }
    
    var task: Moya.Task {
      switch self {
      case .loadHomeItems:
        return .requestPlain
      case .loadItemsDetail:
        return .requestPlain
      }
    }
    
    var validationType: ValidationType {
      switch self {
      case .loadHomeItems:
        return .successCodes
      case .loadItemsDetail:
        return .successCodes
      }
    }
}
