//
//  APIConstants.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/18/24.
//

import Foundation
import Moya

struct APIConstants {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    static let auth = "Authorization"
  static let deviceToken = "devicetoken"
    
    static var accessToken: String {
        return "Bearer "
    }
    
    static var refreshToken: String {
        return "Bearer "
    }
    
    static var appleAccessToken: String {
        return ""
    }

  static var deviceTokenValue: String = UUID().uuidString

    static let OS = "OS"
    static let iOS = "iOS"
}

extension APIConstants {
    static var hasSocialTokenHeader: [String: String] {
        return [contentType: applicationJSON,
                auth: appleAccessToken]
    }
    
    static var hasTokenHeader: [String: String] {
        return [contentType: applicationJSON,
                OS: iOS,
                auth: accessToken]
    }
    
    static var hasAccessTokenHeader: [String: String] {
        return [contentType: applicationJSON,
                auth: accessToken]
    }
    
    static var hasRefreshTokenHeader: [String: String] {
        return [contentType: applicationJSON,
                auth: refreshToken]
    }
  
  static var hasDeviceToken: [String: String] {
      return [contentType: applicationJSON,
              auth: refreshToken,
              deviceToken: deviceTokenValue]
  }
    
    static var signUpHeader: [String: String] {
        return [contentType: applicationJSON,
                auth: appleAccessToken,
                OS: iOS]
    }
}
