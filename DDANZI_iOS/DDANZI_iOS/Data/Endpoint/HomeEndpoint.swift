//
//  HomeEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum HomeEndpoint {
    case loadHomeItems(Int)
    case loadItemsDetail(String)
}

extension HomeEndpoint: BaseTargetType {
    var headers: Parameters? {
      let isLogin = UserDefaults.standard.bool(forKey: .isLogin)
      switch self {
      case .loadHomeItems:
        return isLogin ? APIConstants.hasAccessTokenHeader : APIConstants.plain
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
      case .loadHomeItems(let page):
        return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
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
