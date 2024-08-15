//
//  IamportEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/15/24.
//

import Foundation

import Moya

enum IamportEndpoint {
  case getAccessToken(body: PortoneAccessTokenRequestDTO)
  case getCertificationInfo(id: String, token: String)
}

extension IamportEndpoint: TargetType {
  var baseURL: URL {
    return URL(string: "https://api.iamport.kr")!
  }
  
  var path: String {
    switch self {
    case .getAccessToken:
      return "/users/getToken"
    case let .getCertificationInfo(id, _):
      return "/certifications/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getAccessToken:
      return .post
    case .getCertificationInfo:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .getAccessToken(body):
      return .requestJSONEncodable(body)
    case .getCertificationInfo:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .getAccessToken:
      return APIConstants.plain
    case let .getCertificationInfo(_, token):
      return [
        APIConstants.contentType : APIConstants.applicationJSON,
        APIConstants.auth : "Bearer \(token)"
      ]
    }
  }
}
