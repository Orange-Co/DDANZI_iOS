//
//  AuthEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum AuthEndpoint {
  case socialLogin
  case certification
  case revoke
  case logout
}

extension AuthEndpoint: BaseTargetType {
  var headers: Parameters? {
    switch self {
    case .socialLogin:
      return APIConstants.signUpHeader
    case .certification:
      return APIConstants.hasAccessTokenHeader
    case .revoke:
      return APIConstants.hasAccessTokenHeader
    case .logout:
      return APIConstants.hasAccessTokenHeader
    }
  }
  
  var path: String {
    switch self {
    case .socialLogin:
      return "/api/v1/auth/signin"
    case .certification:
      return "/api/v1/auth/verification"
    case .revoke:
      return "/api/v1/auth/withdraw"
    case .logout:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .socialLogin:
      return .post
    case .certification:
      return .post
    case .revoke:
      return .delete
    case .logout:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .socialLogin:
      return .requestPlain
    case .certification:
      return .requestPlain
    case .revoke:
      return .requestPlain
    case .logout:
      return .requestPlain
    }
  }
  
  var validationType: ValidationType {
    switch self {
    case .socialLogin:
      return .successCodes
    case .certification:
      return .successCodes
    case .revoke:
      return .successCodes
    case .logout:
      return .successCodes
    }
  }
}
