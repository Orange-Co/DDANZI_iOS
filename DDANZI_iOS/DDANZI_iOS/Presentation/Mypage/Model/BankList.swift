//
//  BankList.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/22/24.
//

import Foundation
struct Bank {
    let code: String
    let name: String
}

struct BankList {
    static let banks: [Bank] = [
        Bank(code: "001", name: "한국은행"),
        Bank(code: "002", name: "산업은행"),
        Bank(code: "003", name: "기업은행"),
        Bank(code: "004", name: "국민은행"),
        Bank(code: "005", name: "외환은행"),
        Bank(code: "007", name: "수협중앙회"),
        Bank(code: "008", name: "수출입은행"),
        Bank(code: "011", name: "농협은행"),
        Bank(code: "012", name: "농협회원조합"),
        Bank(code: "020", name: "우리은행"),
        Bank(code: "023", name: "SC제일은행"),
        Bank(code: "027", name: "한국씨티은행"),
        Bank(code: "031", name: "대구은행"),
        Bank(code: "032", name: "부산은행"),
        Bank(code: "034", name: "광주은행"),
        Bank(code: "035", name: "제주은행"),
        Bank(code: "037", name: "전북은행"),
        Bank(code: "039", name: "경남은행"),
        Bank(code: "045", name: "새마을금고연합회"),
        Bank(code: "048", name: "신협중앙회"),
        Bank(code: "050", name: "상호저축은행"),
        Bank(code: "052", name: "모건스탠리은행"),
        Bank(code: "054", name: "HSBC은행"),
        Bank(code: "055", name: "도이치은행"),
        Bank(code: "056", name: "에이비엔암로은행"),
        Bank(code: "057", name: "제이피모간체이스은행"),
        Bank(code: "058", name: "미즈호코퍼레이트은행"),
        Bank(code: "059", name: "미쓰비시도쿄UFJ은행"),
        Bank(code: "060", name: "BOA"),
        Bank(code: "071", name: "정보통신부 우체국"),
        Bank(code: "076", name: "신용보증기금"),
        Bank(code: "077", name: "기술신용보증기금"),
        Bank(code: "081", name: "하나은행"),
        Bank(code: "088", name: "신한은행"),
        Bank(code: "093", name: "한국주택금융공사"),
        Bank(code: "094", name: "서울보증보험"),
        Bank(code: "095", name: "경찰청"),
        Bank(code: "099", name: "금융결제원"),
        Bank(code: "209", name: "동양종합금융증권"),
        Bank(code: "218", name: "현대증권"),
        Bank(code: "230", name: "미래에셋증권"),
        Bank(code: "238", name: "대우증권"),
        Bank(code: "240", name: "삼성증권"),
        Bank(code: "243", name: "한국투자증권"),
        Bank(code: "247", name: "우리투자증권"),
        Bank(code: "261", name: "교보증권"),
        Bank(code: "262", name: "하이투자증권"),
        Bank(code: "263", name: "에이치엠씨투자증권"),
        Bank(code: "264", name: "키움증권"),
        Bank(code: "265", name: "이트레이드증권"),
        Bank(code: "266", name: "에스케이증권"),
        Bank(code: "267", name: "대신증권"),
        Bank(code: "268", name: "솔로몬투자증권"),
        Bank(code: "269", name: "한화투자증권"),
        Bank(code: "270", name: "하나대투증권"),
        Bank(code: "278", name: "굿모닝신한증권"),
        Bank(code: "279", name: "동부증권"),
        Bank(code: "280", name: "유진투자증권"),
        Bank(code: "287", name: "메리츠증권"),
        Bank(code: "289", name: "엔에이치투자증권"),
        Bank(code: "290", name: "부국증권"),
        Bank(code: "291", name: "신영증권"),
        Bank(code: "292", name: "엘아이지투자증권")
    ]
}
