//
//  ProductModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/18/24.
//

import Foundation
import RxCocoa
import RxDataSources

struct ProductDetailModel {
  let imgURL: String
  let productTitle: String
  let discountRate: Int
  let price: Int
  let beforePrice: Int
  let remainAmount: Int
  let infoURL: String
  let interestCount: Int
  let isImminent: Bool
  let category: String
}
