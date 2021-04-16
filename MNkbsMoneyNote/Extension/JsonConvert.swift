//
//  JsonConvert.swift
//  GRGetReport
//
//  Created by JOJO on 2019/9/12.
//  Copyright © 2019 JOJO. All rights reserved.
//

import Foundation

public extension String {
    
    var toDictionary: [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    var toArray: [[String: AnyObject]]? {
        if let jsonData:Data = self.data(using: String.Encoding.utf8) {
            do {
                 let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String: AnyObject]]
                return array
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
//    func convertStringToDictionary() -> [String:AnyObject]? {
//        if let data = text.data(using: String.Encoding.utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
//            } catch let error as NSError {
//                print(error)
//            }
//        }
//        return nil
//    }
}

public extension Dictionary {
    var toDictionary: String {
        var result:String = ""
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
//    func convertDictionaryToString(dict:[String:AnyObject]) -> String {
//        var result:String = ""
//        do {
//            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
//            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
//
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                result = JSONString
//            }
//
//        } catch {
//            result = ""
//        }
//        return result
//    }
    
    
}

public extension Array {
    
    var toString: String {
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
//    func convertArrayToString(arr:[AnyObject]) -> String {
//        var result:String = ""
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.init(rawValue: 0))
//            
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                result = JSONString
//            }
//            
//        } catch {
//            result = ""
//        }
//        return result
//    }
    
}
 

 
