//
//  HomeUseCase.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import Foundation

import Kingfisher

protocol HomeUseCase {
  func fetchHomeItemModel() -> HomeItemEntity?
}

final class HomeUseCaseImp: HomeUseCase {
  
  let homeRepository: any HomeRepository
  
  init(homeRepository: any HomeRepository) {
    self.homeRepository = homeRepository
  }
  
  func fetchHomeItemModel() -> HomeItemEntity? {
    let dto = homeRepository.fetchHomeProduct()
    var productList: [HomeProduct] = []
    dto.productList.forEach {
      productList.append(.init(kakaoProductID: $0.kakaoProductID,
                               image: $0.imgURL,
                               title: $0.name,
                               beforePrice: $0.originPrice.toKoreanWon(),
                               price: $0.salePrice.toKoreanWon(),
                               interestCount: $0.interestCount))
    }
    return .init(homeBannerImage: dto.homeImgURL, products: productList)
    
  }
  
  
}
