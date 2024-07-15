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
  
  var ststusString: String {
    switch self {
    case .inProgress:
      "판매 중"
    case .orderComplete:
      "주문 완료"
    case .deposit:
      "입금 완료"
    case .delivery:
      "배송 중"
    case .complete:
      "거래 완료"
    case .cancel:
      "거래 취소"
    }
  }
}

struct Status {
  var code: String
  var status: StatusType
}

struct Product {
  var image: UIImage
  var productName: String
  var price: String
}

struct Address {
  var name: String
  var address: String
  var phone: String
}

struct Info {
  var title: String
  var info: String
}
