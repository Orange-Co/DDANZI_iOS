//
//  FetchOrderDetailResponseDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/20/24.
//

import Foundation

// MARK: - FetchOrderDetailResponseDTO
struct FetchOrderDetailResponseDTO: Codable {
  let orderID, orderStatus, productName: String
  let imgURL: String
  let originPrice: Int
  let addressInfo: AddressInfo
  let sellerNickname, paymentMethod: String
  let paidAt: String?
  let discountPrice, charge, totalPrice: Int
  
  enum CodingKeys: String, CodingKey {
    case orderID = "orderId"
    case orderStatus, productName
    case imgURL = "imgUrl"
    case originPrice, addressInfo, sellerNickname, paymentMethod, paidAt, discountPrice, charge, totalPrice
  }
}
