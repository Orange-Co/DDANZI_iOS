//
//  UserDefaltManager.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/14/24.
//

import Foundation
import Foundation

// Enum for UserDefaults keys
enum UserDefaultsKeyType: String {
  case refreshToken = "refreshtoken"
  case accesstoken = "accesstoken"
  case nickName = "nickName"
  case portoneAccessToken = "portoneAccessToken"
  case isLogin
  case name = "name"
  case phone = "phone"
  case fcmToken = "fcmToken"
}

extension UserDefaults {
  
  // MARK: - Save Methods
  
  func set(_ value: String, forKey key: UserDefaultsKeyType) {
    set(value, forKey: key.rawValue)
  }
  
  func set(_ value: Bool, forKey key: UserDefaultsKeyType) {
    set(value, forKey: key.rawValue)
  }
  
  func set(_ value: Int, forKey key: UserDefaultsKeyType) {
    set(value, forKey: key.rawValue)
  }
  
  // MARK: - Retrieve Methods
  
  func string(forKey key: UserDefaultsKeyType) -> String? {
    return string(forKey: key.rawValue)
  }
  
  func bool(forKey key: UserDefaultsKeyType) -> Bool {
    return bool(forKey: key.rawValue)
  }
  
  func integer(forKey key: UserDefaultsKeyType) -> Int {
    return integer(forKey: key.rawValue)
  }
  
  // MARK: - Remove Method
  
  func removeObject(forKey key: UserDefaultsKeyType) {
    removeObject(forKey: key.rawValue)
  }
  
  func clearAll() {
    guard let appDomain = Bundle.main.bundleIdentifier else { return }
    removePersistentDomain(forName: appDomain)
    synchronize()
  }
}
