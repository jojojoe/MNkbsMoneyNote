//
//  MNDBManager.swift
//  MNkbsMoneyNote
//
//  Created by Joe on 2021/4/17.
//

import UIKit
import SQLite
import SwiftyJSON

struct MoneyNoteModel {
    
    var systemDate: String // 唯一标识符
    var recordDate: String // 时间戳字符串
    var priceStr: String
    var remarkStr: String
    var tagJsonStr: String = ""
    var tagModelList: [MNkbsTagItem]
    
    
    init(sysDate: String, recorDate: String, price: String, remark: String, tagJson: String, tagModel: [MNkbsTagItem]) {
        systemDate = sysDate
        recordDate = recorDate
        priceStr = price
        remarkStr = remark
        tagJsonStr = tagJson
        tagModelList = tagModel
    }
    
}


extension MNDBManager {

    func filterNote(tagNameList: [String], timeType: TimeFitlerType, completionBlock: (([MoneyNoteModel])->Void)?) {
      
        let beginTimeDate = beginTimeDateFor(timeType: timeType)
        let endTimeDate = Date.today()
        
        selectNoteRecordTags(tagNames: tagNameList, beginTime: beginTimeDate, endTime: endTimeDate, completionBlock: completionBlock)

    }
    
    
    func beginTimeDateFor(timeType: TimeFitlerType) -> Date {
        var beginTimeDate = Date.today()
        switch timeType {
        case .week:
            beginTimeDate = Date.today().previous(.monday, considerToday: true)
            break
        case .month:
            beginTimeDate = Date().startOfCurrentMonth()
            break
        case .year:
            beginTimeDate = Date().startOfCurrentYear()
            break
        case .all:
            beginTimeDate = Date(timeIntervalSince1970: 0)
            break
        case .custom:
            beginTimeDate = Date(timeIntervalSince1970: 0)
            break
        }
        return beginTimeDate
    }
}


class MNDBManager: NSObject {
    
    static let `default` = MNDBManager()
    var db: Connection?
    func prepareDB() {
        do {
            db = try Connection(dbPath())
            createTables()
        } catch {
            debugPrint("prepare database error: \(error)")
        }
    }
    
    fileprivate func dbPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath = documentPaths.first ?? ""
        let dbPath = "\(documentPath)/MoneyNote.sqlite"
        debugPrint("dbPath: \(dbPath)")
        return dbPath
    }
    
    fileprivate func createTables() {
        createMoneyNoteListTable()
        createMoneyTagRecordListTable()
        createTagListTable()
    }
}


extension MNDBManager {
    /// 创建 MoneyNoteList TABLE
    fileprivate func createMoneyNoteListTable() {
        let table = Table("MoneyNoteList")
        let systemDate = Expression<String>("systemDate") // id
        let recordDate = Expression<String>("recordDate")
        let priceStr = Expression<String>("priceStr")
        let remarkStr = Expression<String>("remarkStr")
        let tagJsonStr = Expression<String>("tagJsonStr")
        
        do {
            try db?.run(table.create { t in
                t.column(systemDate, primaryKey: true)
                t.column(recordDate)
                t.column(priceStr)
                t.column(remarkStr)
                t.column(tagJsonStr)
                
            })
        } catch {
            debugPrint("dberror: create table failed. - \("MoneyNoteList")")
        }
    }
    
    
    /// 创建 MoneyTagRecordList TABLE
    fileprivate func createMoneyTagRecordListTable() {
        let table = Table("MoneyTagRecordList")
        // 每一个记录项目里面的tag都单独记出来 用来通过tag查找
        // money note 记录的 systemDate
        let noteSystemDate = Expression<String>("systemDate")
        // tag name
        let tagName = Expression<String>("tagName")
        // recordDate
        let noteRecordDate = Expression<String>("recordDate")
        let indexCount = Expression<String>("indexCount")
        do {
            try db?.run(table.create { t in
                t.column(noteSystemDate, primaryKey: true)
                t.column(tagName)
                t.column(noteRecordDate)
                t.column(indexCount)
                
            })
        } catch {
            debugPrint("dberror: create table failed. - \("MoneyTagRecordList")")
        }
    }
    
    
    /// 创建 TagList TABLE
    fileprivate func createTagListTable() {
        let table = Table("TagList")
        
        let tagName = Expression<String>("tagName")
        // tag name
        let tagColor = Expression<String>("tagColor")
        // tagIndex 更改顺序 排序用
        let tagIndex = Expression<String>("tagIndex")
        
        
        do {
            try db?.run(table.create { t in
                t.column(tagName, primaryKey: true)
                t.column(tagColor)
                t.column(tagIndex)
                
            })
        } catch {
            debugPrint("dberror: create table failed. - \("TagList")")
        }
    }
}

extension MNDBManager {
    // MoneyNoteModel
    func addMoneyNoteItem(model: MoneyNoteModel, completionBlock: (()->Void)?) {
        do {
            
            let insetSql = try db?.prepare("INSERT OR REPLACE INTO MoneyNoteList (systemDate, recordDate, priceStr, remarkStr, tagJsonStr) VALUES (?,?,?,?,?)")
            try insetSql?.run([model.systemDate, model.recordDate, model.priceStr, model.remarkStr, model.tagJsonStr])
            // delete taglist
            deleteMoneyTagRecordList(recordDate: model.recordDate) {
                [weak self] in
                guard let `self` = self else {return}
                // add money tag record
                
                for (ind, tagModel) in model.tagModelList.enumerated() {
                    
                    self.addMoneyTagRecord(systemDate: CLongLong(round(Date().unixTimestamp*1000)).string, tagName: tagModel.tagName, recordDate: model.recordDate, indexCount: ind.string) {
                        completionBlock?()
                    }
                }
            }
        } catch {
            debugPrint("error = \(error)")
        }
    }
    // MoneyNoteModel
    func deleteMoneyNoteItem(model: MoneyNoteModel, completionBlock: (()->Void)?) {
        let table = Table("MoneyNoteList")
        let db_systemDate = Expression<String>("systemDate")
        
        let deleteItem = table.filter(db_systemDate == model.systemDate)
        
        do {
            try db?.run(deleteItem.delete())
            deleteMoneyTagRecordList(recordDate: model.systemDate) {
                completionBlock?()
            }
             
        } catch {
            debugPrint("dberror: delete table failed :\(db_systemDate)")
        }
    }
   
    // MoneyNoteModel
    func selectAllMoneyNoteItem(completionBlock: (([MoneyNoteModel])->Void)?) {
        var moneyNoteList: [MoneyNoteModel] = []
        do {
            if let results = try db?.prepare("select * from MoneyNoteList ORDER BY recordDate DESC;") {
                for row in results {
                    
                    let sysDate_m = row[0] as? String ?? ""
                    let recorDate_m = row[1] as? String ?? ""
                    let price_m = row[2] as? String ?? ""
                    let remark_m = row[3] as? String ?? ""
                    let tagJson_m = row[4] as? String ?? ""
                    let data = try JSON.init(parseJSON: tagJson_m).rawData()
                    let tagListModel = try JSONDecoder().decode([MNkbsTagItem].self, from: data)
                    
                    
                    let item = MoneyNoteModel(sysDate: sysDate_m, recorDate: recorDate_m, price: price_m, remark: remark_m, tagJson: tagJson_m, tagModel: tagListModel)
                    
                    moneyNoteList.append(item)
                }
            }
            completionBlock?(moneyNoteList)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    // priceStr  recordDate
    func selectMoneyNoteItem(beginTime: Date, endTime: Date, _ orderBy: String = "recordDate", completionBlock: (([MoneyNoteModel])->Void)?) {
        let beginTimeStr = CLongLong(round(beginTime.unixTimestamp*1000)).string
        let endTimeStr = CLongLong(round(endTime.unixTimestamp*1000)).string
        
        var moneyNoteList: [MoneyNoteModel] = []
        do {
            if let results = try db?.prepare("select * from MoneyNoteList WHERE recordDate >= '\(beginTimeStr)' AND recordDate < '\(endTimeStr)' ORDER BY \(orderBy) DESC;") {
                for row in results {
                    
                    let sysDate_m = row[0] as? String ?? ""
                    let recorDate_m = row[1] as? String ?? ""
                    let price_m = row[2] as? String ?? ""
                    let remark_m = row[3] as? String ?? ""
                    let tagJson_m = row[4] as? String ?? ""
                    let data = try JSON.init(parseJSON: tagJson_m).rawData()
                    let tagListModel = try JSONDecoder().decode([MNkbsTagItem].self, from: data)
                    
                    let item = MoneyNoteModel(sysDate: sysDate_m, recorDate: recorDate_m, price: price_m, remark: remark_m, tagJson: tagJson_m, tagModel: tagListModel)
                    
                    moneyNoteList.append(item)
                }
            }
            
            moneyNoteList = moneyNoteList.sorted { A, B in
                A.priceStr.double() ?? 0 > B.priceStr.double() ?? 0
            }
            
            completionBlock?(moneyNoteList)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
}



extension MNDBManager {
    // TagRecordList
    func addMoneyTagRecord(systemDate: String, tagName: String, recordDate: String, indexCount: String, completionBlock: (()->Void)?) {
        do {
            let insetSql = try db?.prepare("INSERT OR REPLACE INTO MoneyTagRecordList (systemDate, tagName, recordDate, indexCount) VALUES (?,?,?,?)")
            try insetSql?.run([systemDate, tagName, recordDate, indexCount])
        } catch {
            
        }
        
    }
    
    // TagRecordList
    func deleteMoneyTagRecordList(recordDate: String, completionBlock: (()->Void)?) {
        let table = Table("MoneyTagRecordList")
        let db_recordDate = Expression<String>("recordDate")
        let deleteItem = table.filter(db_recordDate == recordDate)
        
        do {
            try db?.run(deleteItem.delete())
        } catch {
            debugPrint("dberror: delete table failed :\(db_recordDate)")
        }
        
        completionBlock?()
    }
    
    // TagRecordList
    func selectNoteRecordTags(tagNames: [String], beginTime: Date, endTime: Date, completionBlock: (([MoneyNoteModel])->Void)?) {
        do {
            let beginTimeStr = CLongLong(round(beginTime.unixTimestamp*1000)).string
            let endTimeStr = CLongLong(round(endTime.unixTimestamp*1000)).string
            
            var moneyNoteList: [MoneyNoteModel] = []
            
            var whereStr = ""
            if tagNames.count >= 1 {
                var wherelist: [String] = []
                for tag in tagNames {
                    //"tagName = '\(tag)'"
                    //"tagName = '\"'\(tag)\""
                    wherelist.append("tagName = '\(tag)'")
                }
                let str = wherelist.joined(separator: " OR ")
                whereStr = "WHERE \(str)"
                whereStr = whereStr.appending(" AND recordDate >= '\(beginTimeStr)' AND recordDate < '\(endTimeStr)' ORDER BY recordDate DESC")
            } else {
                // 当选择要查找的Tag为空数组时 会把默认的空标签也算上
                whereStr = whereStr.appending("WHERE recordDate >= '\(beginTimeStr)' AND recordDate < '\(endTimeStr)' ORDER BY recordDate DESC")
            }
            
            if let results = try db?.prepare("select * from MoneyTagRecordList \(whereStr);") {
                var sysDateList: [String] = []
                for row in results {
                    let recordsysDate_m = row[2] as? String ?? ""
                    if !sysDateList.contains(recordsysDate_m) {
                        sysDateList.append(recordsysDate_m)
                    }
                }
                
                sysDateList = sysDateList.removeDuplicate()
                
                for date in sysDateList {
                    
                    if let results = try db?.prepare("select * from MoneyNoteList WHERE systemDate = \(date);") {
                        for row in results {
                            
                            let sysDate_m = row[0] as? String ?? ""
                            let recorDate_m = row[1] as? String ?? ""
                            let price_m = row[2] as? String ?? ""
                            let remark_m = row[3] as? String ?? ""
                            let tagJson_m = row[4] as? String ?? ""
                            let data = try JSON.init(parseJSON: tagJson_m).rawData()
                            let tagListModel = try JSONDecoder().decode([MNkbsTagItem].self, from: data)
                            
                            
                            let item = MoneyNoteModel(sysDate: sysDate_m, recorDate: recorDate_m, price: price_m, remark: remark_m, tagJson: tagJson_m, tagModel: tagListModel)
                            
                            moneyNoteList.append(item)
                        }
                    }
                }
                
            }
            completionBlock?(moneyNoteList)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
    
}



extension MNDBManager {
    // TagList
    func addMoneyTag(tagName: String, tagColor: String, tagIndex: String, completionBlock: (()->Void)?) {
        do {
            let insetSql = try db?.prepare("INSERT OR REPLACE INTO TagList (tagName, tagColor, tagIndex) VALUES (?,?,?)")
            try insetSql?.run([tagName, tagColor, tagIndex])
            completionBlock?()
        } catch {
            debugPrint(error)
        }
    }
    // TagList
    func deleteMoneyTag(tagName: String, completionBlock: (()->Void)?) {
        
        let table = Table("TagList")
        let db_tagName = Expression<String>("tagName")
        let deleteItem = table.filter(db_tagName == tagName)
        
        do {
            try db?.run(deleteItem.delete())
        } catch {
            debugPrint("dberror: delete table failed :\(db_tagName)")
        }
        
        completionBlock?()
    }
    // TagList
    func deleteAllMoneyTag(completionBlock: (()->Void)?) {
        
        let table = Table("TagList")
        do {
            try db?.run(table.delete())
        } catch {
            debugPrint("dberror: delete table failed :\(table)")
        }
        
        completionBlock?()
    }
    // TagList
    func selectTagList(completionBlock: (([MNkbsTagItem])->Void)?) {
        var tagList: [MNkbsTagItem] = []
        do {
            if let results = try db?.prepare("select * from TagList ORDER BY tagIndex ASC;") {
                for row in results {
                    
                    let tagName_m = row[0] as? String ?? ""
                    let bgColor_m = row[1] as? String ?? ""
                    let tagIndex_m = row[2] as? String ?? ""
                    let item = MNkbsTagItem(bgColor: bgColor_m, tagName: tagName_m, tagIndex: tagIndex_m)
                    tagList.append(item)
                    
                    
//                    if tagName_m != "+--+" && bgColor_m != "1000000" {
//                        
//                    }
                    
                }
            }
            completionBlock?(tagList)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
    
}




