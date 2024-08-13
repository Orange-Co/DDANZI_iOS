//
//  ProductRepository.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit

import Moya

protocol HomeRepository {
  associatedtype Provider: TargetType
  
  var provider: NetworkProvider<Provider> { get }
  
  init(provider: NetworkProvider<Provider>)
  
  func fetchHomeProduct() -> HomeItemsResponseDTO
  //func fetchHomeProductDetail(id: Int) -> ProductDetailResponseDTO
}
