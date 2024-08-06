//
//  AuthRepository.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation

import Moya

enum AuthRouter {
    case socialLogin(data: SocialLoginRequestDTO)
    case signUp(data: SignUpRequestDTO)
    case tokenRefresh
    case revoke
    case logout
}

extension AuthRouter: BaseTargetType {
    var headers: Parameters? {
        switch self {
        case .socialLogin:
            return APIConstants.hasSocialTokenHeader
        case .signUp:
            return APIConstants.signUpHeader
        case .tokenRefresh:
            return APIConstants.hasRefreshTokenHeader
        case .revoke:
            return APIConstants.hasTokenHeader
        case .logout:
            return APIConstants.hasTokenHeader
        }
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return "/v1/user/login"
        case .signUp:
            return "/v1/user/signup"
        case .tokenRefresh:
            return "/v1/user/reissue"
        case .revoke:
            return "/v1/user"
        case .logout:
            return "/v1/user/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialLogin:
            return .post
        case .signUp:
            return .post
        case .tokenRefresh:
            return .post
        case .revoke:
            return .delete
        case .logout:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .socialLogin(let data):
            return .requestJSONEncodable(data)
        case .signUp(let data):
            return .requestJSONEncodable(data)
        case .tokenRefresh:
            return .requestPlain
        case .revoke:
            return .requestPlain
        case .logout:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        switch self {
        case .socialLogin(data:_) :
            return .none
        case .signUp(data:_):
            return .successCodes
        case .tokenRefresh:
            return .successCodes
        case .revoke:
            return .successCodes
        case .logout:
            return .successCodes
        }
    }
}
