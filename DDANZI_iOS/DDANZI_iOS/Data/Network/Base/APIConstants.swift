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
  static let nickname = "nickname"
  static let refreshtoken = "refreshtoken"
  
  static var accessToken: String {
    if let accessToken = KeychainWrapper.shared.accessToken {
      return "Bearer \(accessToken)"
    } else if let accessToken = UserDefaults.standard.string(forKey: .accesstoken) {
      return "Bearer \(accessToken)"
    }
    return "Bearer \(KeychainWrapper.shared.accessToken ?? "")"
  }
  
  static var refreshToken: String {
    return "\(UserDefaults.standard.string(forKey: .refreshToken) ?? "")"
  }
  
  static var appleAccessToken: String {
    return ""
  }
  
  static var deviceTokenValue: String = KeychainWrapper.shared.deviceUUID
  static var nickNameValue: String = UserDefaults.standard.string(forKey: .nickName) ?? ""
  
  static let OS = "OS"
  static let iOS = "iOS"
}

extension APIConstants {
  static var plain: [String: String] {
    return [contentType: applicationJSON]
  }
  
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
           refreshtoken: refreshToken]
  }
  
  static var hasDeviceToken: [String: String] {
    return [contentType: applicationJSON,
                   auth: refreshToken,
            deviceToken: deviceTokenValue]
  }
  
  static var hasNickname: [String: String] {
    return [contentType: applicationJSON,
                   auth: accessToken,
               nickname: nickNameValue,
            deviceToken: deviceTokenValue]
  }
  
  static var signUpHeader: [String: String] {
    return [contentType: applicationJSON,
                     OS: iOS]
  }
  
  static var imageHeader: [String: String] {
    return [contentType: "image/jpeg"]
  }
}
