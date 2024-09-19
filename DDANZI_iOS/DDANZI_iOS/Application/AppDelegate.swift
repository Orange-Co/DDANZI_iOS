//
//  AppDelegate.swift
//  DDANZI_iOS
//
//  Created by 이지희 on 6/13/24.
//

import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging
import Amplitude

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    /// 카카오 SDK
    KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
    /// Firebase SDK
    FirebaseApp.configure()
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    
    application.registerForRemoteNotifications()
    
    Messaging.messaging().delegate = self
    /// Amplitude
    Amplitude.instance().defaultTracking = AMPDefaultTrackingOptions.initWithSessions(false, appLifecycles: true, deepLinks: false, screenViews: false)
    Amplitude.instance().initializeApiKey(Config.amplitudeKey)
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    return false
  }
  
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  // 백그라운드에서 푸시 알림을 탭했을 때 실행
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNS token: \(deviceToken)")
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // Foreground(앱 켜진 상태)에서도 알림 오는 설정
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.list, .banner])
  }
  
  // 백그라운드에서 푸시 알림을 탭했을 때 실행
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    // 푸시 알림의 userInfo에서 필요한 데이터를 가져옴 (필요에 따라 확장 가능)
     let userInfo = response.notification.request.content.userInfo

     // 앱의 최상위 ViewController에서 화면 전환 로직을 처리
     let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
     if let window = scene?.windows.first,
        let rootViewController = window.rootViewController as? UINavigationController {

       // PushViewController로 이동
       let viewController = PushViewController() // 이동할 ViewController 인스턴스
       rootViewController.pushViewController(viewController, animated: true)
     }

     completionHandler()
   }
}

extension AppDelegate: MessagingDelegate {
  
  // 파이어베이스 MessagingDelegate 설정
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    guard let fcmToken = fcmToken else {
      print("fcmToken 오류 발생")
      return
    }
    
    UserDefaults.standard.set(fcmToken, forKey: .fcmToken)
    
    let dataDict: [String: String] = ["token": fcmToken]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
  }
}
