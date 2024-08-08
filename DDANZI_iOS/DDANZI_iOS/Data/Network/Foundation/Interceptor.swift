//
//  Interceptor.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import Foundation

import Alamofire
import Moya

///// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class AuthInterceptor: RequestInterceptor {
  
  private var retryLimit = 2
  static let shared = AuthInterceptor()
  
  private init() {}
  
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    print("---adater 진입----")
    completion(.success(urlRequest))
  }
  
  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    print("-------🔧retry 시작🔧-------")
    guard let statusCode = request.response?.statusCode
    else {
      print("🚨재시도 횟수가 너무 많습니다")
      return completion(.doNotRetry)
    }
  
    if  request.retryCount < retryLimit {
      if let statusCode = request.response?.statusCode,
         request.retryCount < retryLimit {
        if statusCode == 401 {
          
        } else if statusCode == 404 {
          
        } else {
          completion(.doNotRetryWithError(error))
          return
        }
      }
    }
  }
}
  
  
