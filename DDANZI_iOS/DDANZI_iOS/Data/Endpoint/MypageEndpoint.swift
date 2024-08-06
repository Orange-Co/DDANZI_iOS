//
//  MypageEndpoint.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum MypageEndpoint {
  /// 유저 관련 API
  case fetchUser
  case fetchUserPurchase
  case fetchUserSale
  case fetchUserInterest
  case fetchUerSetting
  
  /// 주소 관련 API
  case fetchUserAddress
  case addUserAddress
  case editUserAddress(Int)
  case deleteUserAddress(Int)
  case settingUserNoti
}

extension MypageEndpoint: BaseTargetType {
    var headers: Parameters? {
      return APIConstants.hasAccessTokenHeader
    }
    
    var path: String {
      switch self {
      case .fetchUser:
        return "/api/v1/mypage"
      case .fetchUserPurchase:
        return "/api/v1/mypage/order"
      case .fetchUserSale:
        return "/api/v1/mypage/item"
      case .fetchUserInterest:
        return "/api/v1/mypage/interest"
      case .fetchUerSetting:
        return "/api/v1/mypage/setting"
      case .fetchUserAddress:
        return "/api/v1/mypage/setting/address"
      case .addUserAddress:
        return "/api/v1/mypage/setting/address"
      case let .editUserAddress(id):
        return "/api/v1/mypage/setting/address/\(id)"
      case let .deleteUserAddress(id):
        return "/api/v1/mypage/setting/address/\(id)"
      case .settingUserNoti:
        return "/api/v1/mypage/setting/pushAlarm"
      }
    }
    
    var method: Moya.Method {
      switch self {
      case .fetchUser:
        return .get
      case .fetchUserPurchase:
        return .get
      case .fetchUserSale:
        return .get
      case .fetchUserInterest:
        return .get
      case .fetchUerSetting:
        return .get
      case .fetchUserAddress:
        return .get
      case .addUserAddress:
        return .post
      case .editUserAddress:
        return .put
      case .deleteUserAddress:
        return .delete
      case .settingUserNoti:
        return .put
      }
    }
    
    var task: Moya.Task {
      switch self {
      case .fetchUser:
        return .requestPlain
      case .fetchUserPurchase:
        return .requestPlain
      case .fetchUserSale:
        return .requestPlain
      case .fetchUserInterest:
        return .requestPlain
      case .fetchUerSetting:
        return .requestPlain
      case .fetchUserAddress:
        return .requestPlain
      case .addUserAddress:
        return .requestPlain
      case .editUserAddress:
        return .requestPlain
      case .deleteUserAddress:
        return .requestPlain
      case .settingUserNoti:
        return .requestPlain
      }
    }
    
    var validationType: ValidationType {
      return .successCodes
    }
}
