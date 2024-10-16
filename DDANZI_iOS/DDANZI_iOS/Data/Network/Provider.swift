//
//  Provider.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/2/24.
//

import Foundation
import Moya

struct Providers {
  static let AuthProvider = NetworkProvider<AuthEndpoint>(withAuth: false)
  static let HomeProvider = NetworkProvider<HomeEndpoint>(withAuth: true)
  static let SearchProvider = NetworkProvider<SearchEndpoint>(withAuth: true)
  static let InterestProvider = NetworkProvider<InterestEndpoint>(withAuth: true)
  static let MypageProvider = NetworkProvider<MypageEndpoint>(withAuth: true)
  static let PortOneProvider = NetworkProvider<IamportEndpoint>(withAuth: false)
  static let OrderProvider = NetworkProvider<OrderEndpoint>(withAuth: true)
  static let PaymentProvider = NetworkProvider<PaymentEndpoint>(withAuth: true)
  static let ItemProvider = NetworkProvider<ItemEndpoint>(withAuth: true)
  static let NotificationProvider = NetworkProvider<NotificationEndpoint>(withAuth: true)
}

extension MoyaProvider {
  convenience init(withAuth: Bool) {
    if withAuth {
      self.init(session: Session(interceptor: AuthInterceptor()),
                plugins: [MoyaLoggingPlugin()])
    } else {
      self.init(plugins: [MoyaLoggingPlugin()])
    }
  }
}
