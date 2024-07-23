//
//  NetworkHelper.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 7/18/24.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dic ?? [:]
        } catch {
            return [:]
        }
    }
}

struct NetworkHelper {
    private init() {}
    
    // 상태 코드와 데이터, decoding type을 가지고 통신의 결과를 핸들링하는 함수
    static func parseJSON<T: Codable> (by statusCode: Int, data: Data, type: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()

        guard let decodedData = try? decoder.decode(BaseResponse<T>.self, from: data) else { return .pathErr }
        
        switch statusCode {
        case 200..<300: return .success(decodedData.data as Any)
        case 400..<500: return .requestErr(decodedData.data as Any)
        case 500..<600: return .serverErr
        default: return .networkFail
        }
    }
    
}
