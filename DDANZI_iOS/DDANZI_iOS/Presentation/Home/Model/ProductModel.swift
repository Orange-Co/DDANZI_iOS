//
//  ProductModel.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/16/24.
//

import UIKit

struct ProductModel {
  let image: UIImage?
  let title: String
  let beforePrice: String
  let price: String
  let heartCount: Int
}

struct SearchProductModel {
  let imageURL: String
  let title: String
  let beforePrice: String
  let price: String
  let heartCount: Int
}
