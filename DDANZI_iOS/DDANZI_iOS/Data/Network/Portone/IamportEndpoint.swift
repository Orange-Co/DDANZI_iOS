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
  case getCertificationInfo(id: String)
}

extension IamportEndpoint: TargetType {
  var baseURL: URL {
    return URL(string: "api.iamport.kr")!
  }
  
  var path: String {
    switch self {
    case .getAccessToken:
      return "/users/getToken"
    case let .getCertificationInfo(id):
      return "/certifications/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getAccessToken:
      return .get
    case .getCertificationInfo(let id):
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
    case .getAccessToken(let body):
      return APIConstants.plain
    case .getCertificationInfo(let id):
      return APIConstants.portOneAuth
    }
  }
}


struct PortoneAccessTokenRequestDTO: Encodable {
  let imp_key: String
  let imp_secret: String
}

struct PortoneBaseResponse: 
