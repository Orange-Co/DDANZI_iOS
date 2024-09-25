//
//  Keychainwrapper.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/15/24.
//

import Foundation

public final class KeychainWrapper {
  public static let shared = KeychainWrapper()
  
  // MARK: - Key
  
  public let userKey = "com.orangeCo.DDANZI-iOS.user"
  public let UUIDKey = "com.orangeCo.DDANZI-iOS.uuid"
  
  public var isAccessTokenEx = true
  
  // MARK: - deviceUUID
  
  public var deviceUUID: String {
    var query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: UUIDKey,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecReturnData: true
    ]
    var item: CFTypeRef?
    var status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess,
       let existingItem = item as? Data,
       let uuid = String(data: existingItem, encoding: .utf8) {
      return uuid
    }
    
    let deviceUUID = UUID().uuidString
    query = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: UUIDKey,
      kSecValueData: deviceUUID.data(using: .utf8) as Any
    ]
    
    status = SecItemAdd(query as CFDictionary, nil)
    
    if status != errSecSuccess {
      /// UUID 저장에 실패한 경우, 기존 항목을 삭제하고 다시 시도
      if status == errSecDuplicateItem {
        SecItemDelete(query as CFDictionary)
        status = SecItemAdd(query as CFDictionary, nil)
      }
      if status != errSecSuccess {
        assert(status == errSecSuccess, "deviceUUID (\(deviceUUID)) 키체인 저장 실패")
      }
    }
    return deviceUUID
  }
  
  // MARK: - AccessToken
  
  public var accessToken: String? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecReturnAttributes: true,
      kSecReturnData: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess,
       let existingItem = item as? [String: Any],
       let accessTokenData = existingItem[kSecValueData as String] as? Data,
       let accessToken =  String(data: accessTokenData, encoding: .utf8)
    {
      return accessToken
    } else {
      print("키체인에서 AccessToken 불러오기 실패: \(status)")
      return nil
    }
  }
  
  public func setAccessToken(_ accessToken: String?) -> Bool {
    if let accessToken = accessToken {
      if self.accessToken == nil {
        return addAccessToken(accessToken)
      } else {
        return updateAccessToken(accessToken)
      }
    } else {
      return deleteAccessToken()
    }
  }
  
  private func addAccessToken(_ accessToken: String) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
      kSecAttrAccount: "AccessToken",
      kSecValueData: (accessToken as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any,
      kSecAttrLabel: "AccessToken"
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status == errSecDuplicateItem {
      return updateAccessToken(accessToken)
    } else {
      assert(status == errSecSuccess, "AccessToken 키체인 저장 실패")
      return status == errSecSuccess
    }
  }
  
  private func updateAccessToken(_ accessToken: String) -> Bool {
    let prevQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey,
    ]
    
    let updateQuery: [CFString: Any] = [
      kSecValueData: (accessToken as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any,
      kSecAttrLabel: "AccessToken"
    ]
    
    let status = SecItemUpdate(
      prevQuery as CFDictionary,
      updateQuery as CFDictionary
    )
    assert(status == errSecSuccess, "AccessToken 키체인 갱신 실패")
    return status == errSecSuccess
  }
  
  func deleteAccessToken() -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: userKey
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    if status == errSecItemNotFound {
      print("AccessToken이 존재하지 않아 삭제할 수 없습니다.")
      return true // 이미 없으므로 성공으로 처리
    } else {
      assert(status == errSecSuccess, "AccessToken 키체인 삭제 실패")
      return status == errSecSuccess
    }
  }
}
