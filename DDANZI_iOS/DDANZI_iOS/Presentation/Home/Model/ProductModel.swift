//
//  ProductModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

struct ProductInfoModel {
  let id: String
  let imageURL: String
  let title: String
  let beforePrice: String
  let price: String
  let heartCount: Int
}

struct PurchaseProductModel {
  let productID: Int
  let name, imgURL: String
  let beforePrice: String
  let price: String
  let completedAt: String
}
