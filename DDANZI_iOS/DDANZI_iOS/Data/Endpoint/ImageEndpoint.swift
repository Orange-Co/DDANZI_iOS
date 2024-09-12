//
//  ImageEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

import Moya

enum ImageEndpoint {
  case accuracyImage
}

extension ImageEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .accuracyImage:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .accuracyImage:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .accuracyImage:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .accuracyImage:
      return [:]
    }
  }
  
  
}
