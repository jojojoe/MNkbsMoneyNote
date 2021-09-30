//
//  AppDelegate.swift
//  MNkbsMoneyNote
//
//  Created by Joe on 2021/3/15.
//

import UIKit
import SwiftyStoreKit
import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainVC: MNkbsMainVC = MNkbsMainVC()
//    var mainVC: MNkbsTagEditVC = MNkbsTagEditVC()
    
//    var mainVC: MNkbsNoteListVC = MNkbsNoteListVC()
//    var mainVC: MNkbsInsightVC = MNkbsInsightVC()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //
        var beginTimeDate = Date.today().previous(.monday, considerToday: true)
        var endTimeDate = Date.today()
//
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr_begin = formatter.string(from: beginTimeDate)
        let dateStr_end = formatter.string(from: endTimeDate)
        
        let monthFirst = Date().startOfCurrentMonth()
        let monthLast = Date().endOfCurrentMonth()
        let yearFirst = Date().startOfCurrentYear()
        let yearLast = Date().endOfCurrentYear()


        debugPrint("dateStr_begin = \(dateStr_begin)")
        debugPrint("endTimeDate = \(endTimeDate)")
        debugPrint("monthFirst = \(monthFirst)")
        debugPrint("monthLast = \(monthLast)")
        debugPrint("yearFirst = \(yearFirst)")
        debugPrint("yearLast = \(yearLast)")
        
        // prepare db
        MNDBManager.default.prepareDB()
        
        // test db
        // inset
        let timestamp = CLongLong(round(Date().unixTimestamp*1000)).string
        let tags1 = MNkbsTagItem(bgColor: "#FB7751", tagName: "吃饭", tagIndex: "0")
        let tags2 = MNkbsTagItem(bgColor: "#F07059", tagName: "购物", tagIndex: "1")
        let tags3 = MNkbsTagItem(bgColor: "#206259", tagName: "睡觉", tagIndex: "2")
        let tags1d = MNkbsTagItem(bgColor: "#FB7751", tagName: "吃饭", tagIndex: "0").toDict()
        let tags2d = MNkbsTagItem(bgColor: "#F07059", tagName: "购物", tagIndex: "1").toDict()
        let tags3d = MNkbsTagItem(bgColor: "#206259", tagName: "睡觉", tagIndex: "2").toDict()
        let tagList = [tags1, tags2, tags3]
        let tagListd = [tags1d, tags2d, tags3d]
        
        let model = MoneyNoteModel(sysDate: timestamp, recorDate: timestamp, price: "13.3", remark: "eat meet", tagJson: tagListd.toString, tagModel: tagList)
        // insert
        MNDBManager.default.addMoneyNoteItem(model: model) {
            debugPrint("add complete")
        }
        
        // load
//        MNDBManager.default.selectAllMoneyNoteItem { (list) in
//            debugPrint(list)
//        }
        
        // delete
//        let deleteModel = MoneyNoteModel(sysDate: "1618757283573", recorDate: "1618757283573", price: "13.3", remark: "", tagJson: "", tagModel: [])
//        MNDBManager.default.deleteMoneyNoteItem(model: deleteModel) {
//            debugPrint("delete")
//        }
        
        // select tags note
//        MNDBManager.default.selectNoteRecordTags(tagNames: ["睡觉"]) { (list) in
//            debugPrint("\(list)")
//        }
        
        // 添加内置标签
//        MNDBManager.default.addMoneyTag(tagName: "衣服", tagColor: "001100", tagIndex: "1") {
//            debugPrint("添加内置标签")
//        }
//        MNDBManager.default.addMoneyTag(tagName: "吃饭", tagColor: "001100", tagIndex: "2") {
//            debugPrint("添加内置标签")
//        }
//        MNDBManager.default.addMoneyTag(tagName: "旅游", tagColor: "001100", tagIndex: "3") {
//            debugPrint("添加内置标签")
//        }
        // delete all tag
//        MNDBManager.default.deleteAllMoneyTag {
//            
//        }
        
        // select taglist
//        MNDBManager.default.selectTagList { (taglist) in
//            debugPrint("taglist = \(tagList)")
//        }
        
        initMainVC()
        setupIAP()
        registerNotifications(application)
        
//        MNkbsInsightManager.default.loadAllRecordYearsMonths()
        
//        MNkbsInsightManager.default.fetchInsightDaysMoney(dateMonthString: "2021-06") { list in
//
//        }
        
        MNkbsInsightManager.default.fetchInsightMonthsMoney(dateYearString: "2021") { list in
            
        }
        
//        MNkbsInsightManager.default.fetchGouCheng(beginTime: Date.init(timeIntervalSince1970: 0), endTime: Date()) { insightGouchengList in
//            debugPrint("insightGouchengList = \(insightGouchengList)")
//        }
//        MNkbsInsightManager.default.fetchPaiHang(beginTime: Date.init(timeIntervalSince1970: 0), endTime: Date()) {
//            insightPaihangList in
//                debugPrint("insightPaihangList = \(insightPaihangList)")
//        }
        
        
        
        
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
//                debugPrint("***fontName = \(ft)")
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


