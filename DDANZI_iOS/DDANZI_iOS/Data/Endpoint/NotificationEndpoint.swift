//
//  PushEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import Foundation

import Moya

enum NotificationEndpoint {
  case listPushNotification
}

extension NotificationEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .listPushNotification:
      return "/api/v1/alarm"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .listPushNotification:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .listPushNotification:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .listPushNotification:
      return APIConstants.hasAccessTokenHeader
    }
  }
  
  
}
