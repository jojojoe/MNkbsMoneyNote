//
//  AppDelegate.swift
//  MNkbsMoneyNote
//
//  Created by Joe on 2021/3/15.
//

import UIKit
import SwiftyStoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainVC: MNkbsMainVC = MNkbsMainVC()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initMainVC()
        setupIAP()
        registerNotifications(application)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}


extension AppDelegate {
    func initMainVC() {
        let nav = UINavigationController.init(rootViewController: mainVC)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        #if DEBUG
        for fy in UIFont.familyNames {
            let fts = UIFont.fontNames(forFamilyName: fy)
            for ft in fts {
                debugPrint("***fontName = \(ft)")
            }
        }
        #endif
    }
    
    func setupIAP() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
}

extension AppDelegate {
    // 注册远程推送通知
    func registerNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                    if (result) {
                        if !(error != nil) {
                            // 注册成功
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                            }
                        }
                    } else {
                        //用户不允许推送
                    }
                }
            } else if (setting.authorizationStatus == .denied){
                // 申请用户权限被拒
            } else if (setting.authorizationStatus == .authorized){
                // 用户已授权（再次获取dt）
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                // 未知错误
            }
        }
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}


