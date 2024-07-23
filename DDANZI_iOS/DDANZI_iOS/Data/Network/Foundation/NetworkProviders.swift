//
//  NetworkProviders.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/18/24.
//

import Foundation

import Moya

class NetworkProvider<Provider : TargetType> : MoyaProvider<Provider> {
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
                    if let responseData = String(data: response.data, encoding: .utf8) {
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
}
