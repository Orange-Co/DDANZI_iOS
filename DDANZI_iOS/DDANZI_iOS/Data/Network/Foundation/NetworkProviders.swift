//
//  NetworkProviders.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/18/24.
//

import Foundation

import Moya

// MARK: - Protocol
public protocol NetworkProviderProtocol {
  associatedtype Provider: TargetType
  
  func request<Model: Codable>(
    target: Provider,
    instance: BaseResponse<Model>.Type,
    completion: @escaping (BaseResponse<Model>) -> ()
  )
  
  func request(
    target: Provider,
    completion: @escaping (Bool) -> ()
  )
}


// MARK: - Impl
class NetworkProvider<Provider: TargetType>: MoyaProvider<Provider>, NetworkProviderProtocol {
  func request<Model : Codable>(target : Provider, instance : BaseResponse<Model>.Type , completion : @escaping(BaseResponse<Model>) -> ()){
    self.request(target) { result in
      switch result {
        /// 서버 통신 성공
      case .success(let response):
        if (200..<300).contains(response.statusCode) ||
            response.statusCode == 403 || response.statusCode == 400 {
          if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
            completion(decodeData)
          } else{
            print("🚨 decoding Error 발생")
          }
        } else {
          print("🚨 Client Error")
        }
        /// 서버 통신 실패
      case .failure(let error):
        if let response = error.response {
          if String(data: response.data, encoding: .utf8) != nil {
            if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
              completion(decodeData)
            }
          } else {
            print(error.localizedDescription)
          }
        } else {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  
  func request<Model : Codable>(target : Provider, instance : PortOneBaseResponse<Model>.Type , completion : @escaping(PortOneBaseResponse<Model>) -> ()){
    self.request(target) { result in
      switch result {
        /// 서버 통신 성공
      case .success(let response):
        if (200..<300).contains(response.statusCode) ||
            response.statusCode == 403 || response.statusCode == 400 {
          if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
            completion(decodeData)
          } else{
            print("🚨 decoding Error 발생")
          }
        } else {
          print("🚨 Client Error")
        }
        /// 서버 통신 실패
      case .failure(let error):
        if let response = error.response {
          if String(data: response.data, encoding: .utf8) != nil {
            if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
              completion(decodeData)
            }
          } else {
            print(error.localizedDescription)
          }
        } else {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  func request(
    target: Provider,
    completion: @escaping (Bool) -> ()
  ) {
    self.request(target) { result in
      switch result {
        /// 서버 통신 성공
      case .success(let response):
        if (200..<300).contains(response.statusCode) {
          completion(true)
        } else{
          print("🚨 Image Upload Error 발생")
        }
        /// 서버 통신 실패
      case .failure(let error):
        completion(false)
        guard let response = error.response else {
          print(error.localizedDescription)
          return
        }
      }
    }
  }
}
