//
//  MNkbsSettingManager.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/13.
//

import UIKit

enum CurrencySymbol: String {
    case CNY = "¥"
    case USD = "$"
}

let key_CurrencySymbol = "key_CurrencySymbol"

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
    var bgColor: String = ""
    var tagName: String = ""
    var tagIndex: String = ""
    
    func toDict() -> [String: String] {
        let dict: [String: String] = ["bgColor": bgColor, "tagName": tagName, "tagIndex": tagIndex]
        return dict
    }
    
    
}

class MNkbsTagManager {
    static let `default` = MNkbsTagManager()
    
    func tagList() -> [MNkbsTagItem] {
        let tag1 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "支出")
        let tag2 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "收入")
        let tag3 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "饮食")
        let tag4 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "娱乐")
        let tag5 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "衣服")
        let tag6 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "打车")
        let tag7 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "租房")
        let tag8 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "罚款")
        let tag9 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "玩")
        let tag10 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "午饭")
        let tag11 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "晚饭")
        let tag12 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "买玩具")
        let tag13 = MNkbsTagItem.init(bgColor: "#FCD567", tagName: "搬家")
        let tag14 = MNkbsTagItem.init(bgColor: "#FF5858", tagName: "加班补助")
        let tag15 = MNkbsTagItem.init(bgColor: "#3C62D1", tagName: "买房还贷款")
        let tag16 = MNkbsTagItem.init(bgColor: "#EC74AD", tagName: "奶粉钱")
        
        let list = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9, tag10, tag11, tag12, tag13, tag14, tag15, tag16]
        return list
        
    }
    
}


class MNkbsCurrentRecordManager {
    static let `default` = MNkbsCurrentRecordManager()
    
    var priceStr: String = ""
    var remark: String = ""
    var recordDate: Date = Date()
    var systemDate: Date = Date()
    var tagList: [[String:String]] = []
    // {"bgColor": "", "tagName": ""}
     
    
    
    func clearCurrentRecord() {
        
    }
    
}

