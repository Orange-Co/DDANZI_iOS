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
  case addUserAddress(UserAddressRequestDTO)
  case editUserAddress(Int,UserAddressRequestDTO)
  case deleteUserAddress(Int)
  
  /// 계좌 관련 API
  case fetchUserAccount
  case addUserAccount(UserAccountRequestDTO)
  case editUserAccount(Int,UserAccountRequestDTO)
  case deleteUserAccount(Int)
  
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
      case let .editUserAddress(id, _):
        return "/api/v1/mypage/setting/address/\(id)"
      case let .deleteUserAddress(id):
        return "/api/v1/mypage/setting/address/\(id)"
      case .settingUserNoti:
        return "/api/v1/mypage/setting/pushAlarm"
      case .fetchUserAccount:
        return "/api/v1/mypage/setting/account"
      case .addUserAccount:
        return "/api/v1/mypage/setting/account"
      case let .editUserAccount(id, _):
        return "/api/v1/mypage/setting/account/\(id)"
      case let .deleteUserAccount(id):
        return "/api/v1/mypage/setting/account/\(id)"
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
      case .fetchUserAccount:
        return .get
      case .addUserAccount:
        return .post
      case .editUserAccount:
        return .put
      case .deleteUserAccount:
        return .delete
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
      case let .addUserAddress(body):
        return .requestJSONEncodable(body)
      case let .editUserAddress(_, body):
        return .requestJSONEncodable(body)
      case .deleteUserAddress:
        return .requestPlain
      case .settingUserNoti:
        return .requestPlain
      case .fetchUserAccount:
        return .requestPlain
      case .addUserAccount(let body):
        return .requestJSONEncodable(body)
      case let .editUserAccount(_, body):
        return .requestJSONEncodable(body)
      case .deleteUserAccount(_):
        return .requestPlain
      }
    }
    
    var validationType: ValidationType {
      return .successCodes
    }
}
