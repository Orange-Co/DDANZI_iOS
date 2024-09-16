//
//  itemConfirmedDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

struct itemConformedDTO: Codable {
  let productID, productName: String
     let imgURL: String
     let originPrice, salePrice: Int
     let isAccountExist: Bool

     enum CodingKeys: String, CodingKey {
         case productID = "productId"
         case productName
         case imgURL = "imgUrl"
         case originPrice, salePrice, isAccountExist
     }
 }
