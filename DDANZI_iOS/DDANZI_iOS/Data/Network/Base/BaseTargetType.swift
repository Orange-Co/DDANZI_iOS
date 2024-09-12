//
//  BaseTargetType.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/23/24.
//

import Foundation

import Moya

protocol BaseTargetType: TargetType {}


extension BaseTargetType {
    typealias Parameters = [String: String]
  
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            print("🚨🚨BASEURL ERROR🚨🚨")
            fatalError()
        }
        return baseURL
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
