//
//  PaymentEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

import Moya

enum PaymentEndpoint {
  case startPayment
  case completedPayment
}

extension PaymentEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .startPayment:
      return "/api/v1/payment/start"
    case .completedPayment:
      return "/api/v1/payment/end"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .startPayment:
      return .post
    case .completedPayment:
      return .patch
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .startPayment:
      return .
    case .completedPayment:
      <#code#>
    }
  }
  
  var headers: [String : String]?
  
  
}
