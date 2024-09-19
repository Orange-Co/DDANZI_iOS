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
  case conformedOrderBuy(String)
  case conformedOrderSale(String)
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
    case .conformedOrderBuy:
      return APIConstants.hasAccessTokenHeader
    case .conformedOrderSale:
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
    case .conformedOrderBuy(let id):
      return "/api/v1/order/\(id)/buy"
    case .conformedOrderSale(let id):
      return "/api/v1/order/\(id)/sale"
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
    case .conformedOrderBuy(_):
      return .patch
    case .conformedOrderSale(_):
      return .patch
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
    case .conformedOrderBuy(_):
      return .requestPlain
    case .conformedOrderSale(_):
      return .requestPlain
    }
  }
  
  var validationType: ValidationType {
    return .successCodes
  }
}
