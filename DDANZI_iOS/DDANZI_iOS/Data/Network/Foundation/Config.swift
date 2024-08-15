//
//  Config.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let kakaoAppKey = "NATIVE_APP_KEY"
          static let impCode = "IMP_CODE"
          static let impKey = "IMP_KEY"
          static let impSecret = "IMP_SECRET"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration.")
        }
        return key
    }()
  
  static let kakaoAppKey: String = {
      guard let key = Config.infoDictionary[Keys.Plist.kakaoAppKey] as? String else {
          fatalError("kakaoAppKey is not set in plist for this configuration.")
      }
      return key
  }()
  
  static let impCode: String = {
      guard let key = Config.infoDictionary[Keys.Plist.impCode] as? String else {
          fatalError("impCode is not set in plist for this configuration.")
      }
      return key
  }()
  
  static let impKey: String = {
      guard let key = Config.infoDictionary[Keys.Plist.impKey] as? String else {
          fatalError("impKey is not set in plist for this configuration.")
      }
      return key
  }()
  
  static let impSecret: String = {
      guard let key = Config.infoDictionary[Keys.Plist.impSecret] as? String else {
          fatalError("impSecret is not set in plist for this configuration.")
      }
      return key
  }()
}
