//
//  MNkbsSettingManager.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/13.
//

import UIKit
import Defaults
import NoticeObserveKit


var AppName: String = "App_Name"
var AppBundleID: String = "com.xxx"
var IAPsharedSecret: String = ""
var uploadSubscriptionInfoURLStr: String = "https://"


public enum IAPType: String {
    case year = "IAP_id_year"
    case month = "IAP_id_month"
    
}

enum CurrencySymbol: String {
    case CNY = "¥"
    case USD = "$"
}

let key_CurrencySymbol = "key_CurrencySymbol"


let FONT_MONTSERRAT_BOLDITALIC: String = "Montserrat-BoldItalic"
let FONT_MONTSERRAT_BOLD: String = "Montserrat-Bold"
let FONT_MONTSERRAT_MEDIUM: String = "Montserrat-Medium"
let FONT_MONTSERRAT_SEMIBOLD: String = "Montserrat-SemiBold"
let FONT_MONTSERRAT_REGULAR: String = "Montserrat-Regular"
let FONT_AvenirNextCondensedDemiBold: String = "AvenirNextCondensed-DemiBold"
let FONT_AvenirNextDemiBold: String = "AvenirNext-DemiBold"
let FONT_AvenirNextBold: String = "AvenirNext-Bold"
let FONT_AvenirHeavy: String = "Avenir-Heavy"
let FONT_AvenirMedium: String = "Avenir-Medium"


class MNkbsSettingManager: UIView {

    static let `default` = MNkbsSettingManager()
    
    
    func currencySymbolList() -> [CurrencySymbol] {
        let list = [CurrencySymbol.CNY, CurrencySymbol.USD]
        return list
    }
    func currentCurrencySymbol() -> CurrencySymbol {
        if let currency = UserDefaults.standard.value(forKey: key_CurrencySymbol) as? String {
            return CurrencySymbol.init(rawValue: currency) ?? .CNY
        }
        return .CNY
    }
    func setupCurrencySymbol(currencySymbol: CurrencySymbol) {
        UserDefaults.standard.setValue(currencySymbol, forKey: key_CurrencySymbol)
    }
}

enum NumberType: String {
    case number_0 = "0"
    case number_1 = "1"
    case number_2 = "2"
    case number_3 = "3"
    case number_4 = "4"
    case number_5 = "5"
    case number_6 = "6"
    case number_7 = "7"
    case number_8 = "8"
    case number_9 = "9"
    case number_point = "."
    case number_add = "+"
    case number_sub = "-"
    case number_equal = "="
    case number_delete = "delete"
    case number_done = "done"
}

struct MNkbsNumberItem {
    var numberType: NumberType
    var displayName: String
    
}

class MNkbsNumberManager {
    static let `default` = MNkbsNumberManager()
    let number_0 = MNkbsNumberItem(numberType: .number_0, displayName: "0")
    let number_1 = MNkbsNumberItem(numberType: .number_1, displayName: "1")
    let number_2 = MNkbsNumberItem(numberType: .number_2, displayName: "2")
    let number_3 = MNkbsNumberItem(numberType: .number_3, displayName: "3")
    let number_4 = MNkbsNumberItem(numberType: .number_4, displayName: "4")
    let number_5 = MNkbsNumberItem(numberType: .number_5, displayName: "5")
    let number_6 = MNkbsNumberItem(numberType: .number_6, displayName: "6")
    let number_7 = MNkbsNumberItem(numberType: .number_7, displayName: "7")
    let number_8 = MNkbsNumberItem(numberType: .number_8, displayName: "8")
    let number_9 = MNkbsNumberItem(numberType: .number_9, displayName: "9")
    let number_point = MNkbsNumberItem(numberType: .number_point, displayName: ".")
    let number_delete = MNkbsNumberItem(numberType: .number_delete, displayName: "删除")
    let number_done = MNkbsNumberItem(numberType: .number_done, displayName: "完成")
    let number_add = MNkbsNumberItem(numberType: .number_add, displayName: "+")
    let number_sub = MNkbsNumberItem(numberType: .number_sub, displayName: "-")
    let number_equal = MNkbsNumberItem(numberType: .number_equal, displayName: "=")
    
     
    func processStringToNumType(valueStr: String) -> [NumberType] {
        
        var singleList = valueStr.charactersArray
        if singleList.contains("."), singleList.last == "0" {
            singleList.removeLast()
        }
        var typeList: [NumberType] = []
        for item in singleList {
            if let item = NumberType.init(rawValue: item.string) {
                typeList.append(item)
            }
        }
        return typeList
    }
    
    func processItemsNumber(numberItems: [NumberType]) -> String {
        var numStr = ""
        for item in numberItems {
            switch item {
            case .number_0:
                numStr += "0"
            case .number_1:
                numStr += "1"
            case .number_2:
                numStr += "2"
            case .number_3:
                numStr += "3"
            case .number_4:
                numStr += "4"
            case .number_5:
                numStr += "5"
            case .number_6:
                numStr += "6"
            case .number_7:
                numStr += "7"
            case .number_8:
                numStr += "8"
            case .number_9:
                numStr += "9"
            case .number_point:
                numStr += "."
            case .number_add:
                numStr += "+"
            case .number_sub:
                numStr += "-"
            default:
                numStr += ""
            }
        }
        return numStr
        
    }
    
}

 

struct MNkbsTagItem: Codable {
    var bgColor: String = "#100000"
    var tagName: String = "+--+"
    var tagIndex: String = "999"
     
    
    func toDict() -> [String: String] {
        let dict: [String: String] = ["bgColor": bgColor, "tagName": tagName, "tagIndex": tagIndex]
        return dict
    }
    
}

class MNkbsTagManager {
    static let `default` = MNkbsTagManager()
    
    func testtagList() -> [MNkbsTagItem] {
        let tag1 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "1")
        let tag2 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "2")
        let tag3 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "3")
        let tag4 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "4")
        let tag5 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "5")
        let tag6 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "6")
        let tag7 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "7")
        let tag8 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "8")
        let tag9 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "9")
        let tag10 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "10")
        let tag11 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "11")
        let tag12 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "12")
        let tag13 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "13")
        let tag14 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "14")
        let tag15 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "15")
        let tag16 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "16")
        
        let list = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10, tag11, tag12, tag13, tag14, tag15, tag16]
        
        //
        
        
        
        return list
        
    }
    
}


class MNkbsBgColorManager {
    static let `default` = MNkbsBgColorManager()
    var colorList: [String] = ["#000000", "#FF0000", "#FFFF00", "#FF00FF", "#0000FF", "#FFF000", "#00F0FF", "#0F00F0", "#7F0204", "#FF7021"]
    
     
    
}


extension Defaults.Keys {
    static let localIAPReceiptInfo = Key<Data?>("PurchaseManager.localIAPReceiptInfo")
    static let localIAPProducts = Key<[PurchaseManager.IAPProduct]?>("PurchaseManager.LocalIAPProducts")
    static let localIAPCacheTime = Key<TimeInterval?>("PurchaseManager.localIAPCacheTime")
    
}

extension Notice.Names {
    static let receiptInfoDidChange =
        Notice.Name<Any?>(name: "ReceiptInfoDidChange")
}
 
extension Notice.Names {
    
//    static let mn_noti_TagRefresh = Notice.Name<Any?>(name: "mn_noti_TagRefresh")
    
    
    
//    Notice.Center.default.post(name: Notice.Names.receiptInfoDidChange, with: nil)
//    NotificationCenter.default.nok.observe(name: .keyboardWillShow) { keyboardInfo in
//        print(keyboardInfo)
//    }
//    .invalidated(by: pool)
}
