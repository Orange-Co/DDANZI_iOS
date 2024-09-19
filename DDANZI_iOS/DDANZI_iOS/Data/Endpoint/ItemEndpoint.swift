//
//  ItemEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import Foundation

import Moya

enum ItemEndpoint {
  case requestPresignedURL(body: PresignedURLQuery)
  case uploadImage(url: String, data: Data)
  case itemCheck(body: ItemCheckRequestBody)
  case itemConfirmed(id: String)
  case registeItem(body: RegisteItemBody)
  case detailItem(id: String)
  case optionItem(id: String)
  
}

extension ItemEndpoint: BaseTargetType {
  var baseURL: URL {
    switch self {
    case .uploadImage(let url, _) :
      guard let presignedURL = URL(string: url) else {
        print("presignedURL 오류")
        fatalError()
      }
      return presignedURL
    default:
      guard let baseURL = URL(string: Config.baseURL) else {
          print("🚨🚨BASEURL ERROR🚨🚨")
          fatalError()
      }
      return baseURL
    }
  }
  var path: String {
    switch self {
    case .requestPresignedURL:
      return "/api/v1/item/signed-url"
    case .uploadImage:
      return ""
    case .itemCheck:
      return "/api/v1/item/check"
    case .itemConfirmed(let id):
      return "/api/v1/item/product/\(id)"
    case .registeItem:
      return "/api/v1/item"
    case .detailItem(let id):
      return "/api/v1/item/\(id)"
    case .optionItem(let id):
      return "/api/v1/item/order/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .requestPresignedURL:
      return .get
    case .uploadImage:
      return .put
    case .itemCheck:
      return .post
    case .itemConfirmed:
      return .get
    case .registeItem:
      return .post
    case .detailItem:
      return .get
    case .optionItem:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .requestPresignedURL(let body):
      return .requestParameters(parameters: ["fileName": body.fileName], encoding: URLEncoding.queryString)
    case .uploadImage(_, let data):
      return .requestData(data)
    case .itemCheck(let body):
      return .requestJSONEncodable(body)
    case .itemConfirmed:
      return .requestPlain
    case .registeItem(let body):
      return .requestJSONEncodable(body)
    case .detailItem:
      return .requestPlain
    case .optionItem:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .requestPresignedURL:
      return APIConstants.hasAccessTokenHeader
    case .uploadImage:
      return APIConstants.imageHeader
    case .itemCheck:
      return APIConstants.hasAccessTokenHeader
    case .itemConfirmed:
      return APIConstants.hasAccessTokenHeader
    case .registeItem:
      return APIConstants.hasAccessTokenHeader
    case .detailItem:
      return APIConstants.hasAccessTokenHeader
    case .optionItem:
      return APIConstants.hasAccessTokenHeader
    }
  }
  
}
