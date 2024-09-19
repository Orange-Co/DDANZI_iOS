//
//  HomeRepositoryImp.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit

final class HomeRepositoryImp: HomeRepository {

  typealias Provider = HomeEndpoint
  
  var provider: NetworkProvider<HomeEndpoint>
  
  init(provider: NetworkProvider<HomeEndpoint>) {
    self.provider = provider
  }
  
  func fetchHomeProduct() -> HomeItemsResponseDTO {
    var DTO: HomeItemsResponseDTO = .init(homeImgURL: "", productList: [], pageInfo: .init(totalElements: 0, numberOfElements: 0))
    provider.request(target: .loadHomeItems(0),
                     instance: BaseResponse<HomeItemsResponseDTO>.self) { result in
      guard let resultData = result.data else { return }
      DTO = resultData
    }
    return DTO
  }
  
}
