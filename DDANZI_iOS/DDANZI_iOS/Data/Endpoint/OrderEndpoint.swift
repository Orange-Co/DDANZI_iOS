//
//  OrderEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum OrderEndpoint {
  case fetchOrderInfo(String)
  case executeOrder(body: ExecuteRequestBody)
  case fetchOrderDetail(String)
}

extension OrderEndpoint: BaseTargetType {
  var headers: Parameters? {
    switch self {
    case .fetchOrderInfo:
      return APIConstants.hasAccessTokenHeader
    case .executeOrder:
      return APIConstants.hasAccessTokenHeader
    case .fetchOrderDetail:
      return APIConstants.hasAccessTokenHeader
    }
  }
  
  var path: String {
    switch self {
    case .fetchOrderInfo(let id):
      return "/api/v1/order/product/\(id)"
    case .executeOrder:
      return "/api/v1/order"
    case .fetchOrderDetail(let id):
      return "/api/v1/order/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .fetchOrderInfo:
      return .get
    case .executeOrder:
      return .post
    case .fetchOrderDetail:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .fetchOrderInfo:
      return .requestPlain
    case .executeOrder(let body):
      return .requestJSONEncodable(body)
    case .fetchOrderDetail:
      return .requestPlain
    }
  }
  
  var validationType: ValidationType {
    switch self {
    case .fetchOrderInfo:
      return .successCodes
    case .executeOrder:
      return .successCodes
    case .fetchOrderDetail:
      return .successCodes
    }
  }
}
