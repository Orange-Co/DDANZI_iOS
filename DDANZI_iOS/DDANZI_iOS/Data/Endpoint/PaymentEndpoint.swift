//
//  PaymentEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

import Moya

enum PaymentEndpoint {
  case startPayment(body: PaymentRequestBody)
  case completedPayment(body: PaymentCompletedBody)
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
    case .startPayment(let body):
      return .requestJSONEncodable(body)
    case .completedPayment(let body):
      return .requestJSONEncodable(body)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .startPayment:
      return APIConstants.hasAccessTokenHeader
    case .completedPayment:
      return APIConstants.hasAccessTokenHeader
    }
  }
  
}
