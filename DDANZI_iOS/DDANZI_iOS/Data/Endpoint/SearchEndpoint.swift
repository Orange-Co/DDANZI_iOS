//
//  SearchEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum SearchEndpoint {
  case loadInitalSearch
  case loadSearchResult(SearchQueryDTO)
}

extension SearchEndpoint: BaseTargetType {
  var headers: Parameters? {
    switch self {
    case .loadInitalSearch:
      return APIConstants.hasDeviceToken
    case .loadSearchResult:
      return APIConstants.hasAccessTokenHeader
    }
  }
  
  var path: String {
    switch self {
    case .loadInitalSearch:
      return "/api/v1/search"
    case .loadSearchResult:
      return "/api/v1/search"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .loadInitalSearch:
      return .get
    case .loadSearchResult:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .loadInitalSearch:
      return .requestPlain
    case let .loadSearchResult(query):
      return .requestParameters(parameters: ["keyword": query.keyword], encoding: URLEncoding.queryString)
    }
  }
  
  var validationType: ValidationType {
    return .successCodes
  }
}
