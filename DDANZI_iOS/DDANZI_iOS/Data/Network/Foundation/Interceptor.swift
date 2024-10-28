//
//  Interceptor.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import UIKit

import Alamofire
import Moya

/// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class AuthInterceptor: RequestInterceptor {
  
  private var retryLimit = 2
  
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    completion(.success(urlRequest))
  }
  
  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    print("-------🔧retry 시작🔧-------")
    guard let statusCode = request.response?.statusCode else {
      print("🚨status code 오류")
      return completion(.doNotRetry)
    }
    print("🚨Errpr Status Code: \(statusCode)")
    print("🚨Error Message : \(error.localizedDescription)")
    if request.retryCount < retryLimit {
      if statusCode == 401 {
        print("토큰 재발급 시작")
        refreshToken { success in
          switch success {
          case true:
            completion(.retry)
          case false:
            print("토큰 재발급 실패")
            completion(.doNotRetry)
            self.handleTokenRefreshFailure()
          }
        }
      }
    } else {
      completion(.doNotRetry)
    }
  }
  
}

extension AuthInterceptor {
  private func refreshToken(completion: @escaping (Bool) -> Void) {
    let body = RefreshTokenRequestDTO(refreshtoken: UserDefaults.standard.string(forKey: .refreshToken) ?? "")
    Providers.AuthProvider.request(target: .refreshToken(body), instance: BaseResponse<RefreshTokenDTO>.self) { response in
      guard let data = response.data else {
        // Token refresh failed
        self.handleTokenRefreshFailure()
        completion(false) // Indicate failure
        return
      }
      
      if let accessToken = data.accesstoken {
        KeychainWrapper.shared.setAccessToken(accessToken)
        UserDefaults.standard.set(data.refreshtoken, forKey: .refreshToken)
      }
      
      if response.status == 401 {
        UserDefaults.standard.set(data.refreshtoken, forKey: .refreshToken)
      }
      
      completion(true) // Indicate success
    }
  }
  
  
  private func handleTokenRefreshFailure() {
    // Clear tokens
    KeychainWrapper.shared.deleteAccessToken()
    UserDefaults.standard.removeObject(forKey: .refreshToken)
    
    // Set isLogin to false
    UserDefaults.standard.set(false, forKey: "isLogin")
    
    print("🚨 Token refresh failed. Tokens cleared and isLogin set to false.")
  }
}
