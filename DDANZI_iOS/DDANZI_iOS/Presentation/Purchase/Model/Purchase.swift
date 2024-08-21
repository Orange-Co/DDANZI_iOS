//
//  Purchase.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/21/24.
//

import Foundation

struct PriceModel {
  var title: String
  var price: String
  var type: PriceType
}

struct PurchaseModel {
  let originPrice: Int
  let discountPrice: Int
  let chargePrice: Int
  let totalPrice: Int
}
