//
//  PermissionManager.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 9/9/24.
//

import UIKit
import AVFoundation
import Photos

import RxSwift

/// 권한 상태 확인 및 요청을 위한 싱글톤 클래스
public final class PermissionManager {
  
  public static let shared = PermissionManager()
  private init() { }
  private let disposeBag = DisposeBag()
  
  // MARK: - 권한 상태 확인
  
  private var notificationPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .notDetermined:
          self.requestNotificationPermission()
            .subscribe(onNext: { isAllowed in
              observable.onNext(isAllowed)
              observable.onCompleted()
            })
            .disposed(by: self.disposeBag)
        case .authorized:
          observable.onNext(true)
          observable.onCompleted()
        default:
          observable.onNext(false)
          observable.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  private var photoPermission: Observable<Bool> {
    return Observable<Bool>.create { observable in
      let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
      switch status {
      case .notDetermined:
        self.requestPhotoPermission()
          .subscribe { isAllowed in
            observable.onNext(isAllowed)
            observable.onCompleted()
          }
          .disposed(by: self.disposeBag)
      case .authorized:
        observable.onNext(true)
        observable.onCompleted()
      default:
        observable.onNext(false)
        observable.onCompleted()
      }
     
      return Disposables.create()
    }
  }
  
  /// 권한 상태 확인 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().checkPermission(for: .camera)
  ///   }
  ///   .subscribe(with: self) { owner, status in
  ///     ...
  ///   }
  ///   .disposed(by: disposBag())
  public func checkPermission(for type: PermissionType) -> Observable<Bool> {
    switch type {
    case .notification:
      return notificationPermission
    case .photo:
      return photoPermission
    }
  }
  
  // MARK: - 권한 요청
  
  /// 알림 권한 요청 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().requestNotificationPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestNotificationPermission() -> Observable<Bool> {
    Observable<Bool>.create { observable in
      UNUserNotificationCenter.current()
        .requestAuthorization(
          options: [.alert, .sound, .badge]
        ) { isAllow, _ in
          DispatchQueue.main.async {
            observable.onNext(isAllow)
            observable.onCompleted()
          }
        }
      return Disposables.create()
    }
  }
  
  /// 앨범 권한 요청 메서드
  ///
  /// 사용예시:
  /// ```swift
  /// button.rx.tap
  ///   .flatMap {
  ///     PermissionManager().requestPhotoPermission()
  ///   }
  ///   .subscribe(with: self) { owner, _ in
  ///   }
  ///   .disposed(by: disposBag())
  ///
  public func requestPhotoPermission() -> Observable<Bool> {
    Observable<Bool>.create { observable in
      PHPhotoLibrary.requestAuthorization(for: .addOnly) { state in
        if state == .authorized {
          observable.onNext(true)
          observable.onCompleted()
        } else {
          observable.onNext(false)
          observable.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}

public enum PermissionType {
  case notification, photo
}
