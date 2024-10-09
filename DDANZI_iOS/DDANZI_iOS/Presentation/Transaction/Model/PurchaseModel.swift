//
//  PurchaseModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/10/24.
//

import UIKit
enum StatusType {
  case inProgress
  case orderComplete
  case deposit
  case delivery
  case complete
  case cancel
  case notDeposit
  case onSale
  case delayedShipping
  case warning
  case deleted
  
  var statusString: String {
    switch self {
    case .inProgress, .onSale:
      return "판매 중"
    case .orderComplete:
      return "주문 완료"
    case .deposit:
      return "입금 완료"
    case .delivery,.delayedShipping,.warning:
      return "배송 중"
    case .complete:
      return "거래 완료"
    case .cancel:
      return "거래 취소"
    case .notDeposit:
      return "판매 중"
    case .deleted:
      return "삭제된 상품"
    }
  }
  
  // 문자열 값으로부터 StatusType을 초기화하는 메서드
  init?(rawValue: String) {
    switch rawValue.uppercased() {
    case "ORDER_PENDING":
      self = .notDeposit
    case "ORDER_PLACE":
      self = .deposit
    case "ORDERED":
      self = .orderComplete
    case "SHIPPING":
      self = .delivery
    case "COMPLETED":
      self = .complete
    case "CANCELLED":
      self = .cancel
    case "ON_SALE":
      self = .onSale
    case "DELAYED_SHIPPING":
      self = .delayedShipping
    case "WARNING":
      self = .warning
    case "DELETED":
      self = .deleted
    default:
      return nil
    }
  }
}

struct Status {
  var code: String
  var status: StatusType
}

struct Product {
  var imageURL: String
  var productName: String
  var price: String
}

struct Address {
  var addressId: Int?
  var name: String
  var address: String
  var phone: String
}

struct Info {
  var title: String
  var info: String
}
