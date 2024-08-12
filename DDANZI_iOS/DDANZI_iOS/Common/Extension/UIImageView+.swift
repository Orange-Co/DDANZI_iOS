//
//  UIImageView+.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 8/9/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// URL 문자열을 통해 이미지를 로드하여 UIImageView에 설정하는 함수
    ///
    /// - Parameters:
    ///   - urlString: 이미지 URL 문자열
    ///   - placeholder: 기본 이미지 (옵션)
    ///   - completion: 이미지 로딩 완료 후 호출되는 클로저 (옵션)
    func setImage(with urlString: String?, placeholder: UIImage? = nil, completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        self.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion?(.success(value))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
