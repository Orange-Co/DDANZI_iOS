//
//  PushNotificationListDTO.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/13/24.
//

import Foundation

struct PushNotificationListDTO: Codable {
  let alarmList: [PushNotification]
}

struct PushNotification: Codable {
  let alarmId: Int64                  // 알림 고유 ID (Long 타입은 Int64로 대응)
  let alarmCase: String               // 알림 케이스 (A_1 ~ B_4)
  let title: String                   // 제목
  let content: String                 // 내용
  let time: String                    // 알림 생성 시간 (String)
  let isChecked: Bool                 // 알람 확인 여부 (Boolean)
  let orderId: String?                // 주문 고유 ID (nullable, 구매자일 경우)
  let itemId: String?                 // 제품 고유 ID (nullable, 판매자일 경우)
}
