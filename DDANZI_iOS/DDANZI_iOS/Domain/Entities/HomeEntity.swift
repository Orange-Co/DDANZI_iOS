//
//  HomeItemEntitly.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import Foundation

struct HomeItemEntity {
  var homeBannerImage: String
  var products: [HomeProduct]
}

struct HomeProduct {
  let kakaoProductID: Int
  let image: String
  let title: String
  let beforePrice: String
  let price: String
  let interestCount: Int
}
