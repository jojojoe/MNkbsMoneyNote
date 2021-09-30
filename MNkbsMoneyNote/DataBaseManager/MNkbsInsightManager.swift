//
//  MNkbsInsightManager.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/5/15.
//

import UIKit

struct MNkbsInsightItem {
    var tagName: String = ""
    var percentLine: Double = 0.5
    var priceDouble: Double = 0
    
    
}

class MNkbsInsightChartMonthItem  {
    var xInfoStr: String = ""
    var yNoteItem: [MoneyNoteModel] = []
    init(xInfoStr: String = "", yNoteItem: [MoneyNoteModel] = []) {
        self.xInfoStr = xInfoStr
        self.yNoteItem = yNoteItem
    }
    func totalPrize() -> Double {
        var price: Double = 0
        for item in yNoteItem {
            price += (item.priceStr.double() ?? 0)
        }
        return price
    }
}

class MNkbsInsightChartYearItem  {
    var xInfoStr: String = ""
    var yNoteItem: Double = 0
    init(xInfoStr: String = "", yNoteItem: Double = 0) {
        self.xInfoStr = xInfoStr
        self.yNoteItem = yNoteItem
    }
    
}


class MNkbsInsightManager: NSObject {
    static let `default` = MNkbsInsightManager()
    
    var currentGouChengList: [MNkbsInsightItem] = []
    var currentPaiHangList: [MoneyNoteModel] = []
    var firstInstallDate: Date = Date()
    
    
    func loadFirstInstallDate() {
        let kFirstInstall = "kFirstInstall"
        if let firstDate = UserDefaults.standard.value(forKey: kFirstInstall) as? Date {
            firstInstallDate = firstDate
        } else {
            let firstDate = Date()
            firstInstallDate = firstDate
            UserDefaults.standard.setValue(firstDate, forKey: kFirstInstall)
        }
    }
    
    func loadAllRecordYearsMonths() {
        var firstDateStr = firstInstallDate.string(withFormat: "yyyy-MM-dd")
        var currentDateStr = Date().string(withFormat: "yyyy-MM-dd")
        
        //test
        firstDateStr = "2000-02-02"
        currentDateStr = "2004-08-08"
        
        let firstDateList = firstDateStr.components(separatedBy: "-")
        let currentDateList = currentDateStr.components(separatedBy: "-")
        
        let firstYear = firstDateList.first ?? "1000"
        let firstMonth = firstDateList[safe: 1] ?? "1"
        let currentDateYear = currentDateList.first ?? "1001"
        let currentDateMonth = currentDateList[safe: 1] ?? "1"
        
        let firstMonthInt = (firstMonth.int ?? 1) - 1
        let currentMonthInt = (currentDateMonth.int ?? 1) - 1
        
        var dateList: [[String:Any]] = []
        
        // 添加首次
        var firstMonths: [String] = []
        for i in firstMonthInt...11 {
            firstMonths.append(i.string)
        }
        let firstDict: [String : Any] = ["year":firstYear, "month" : firstMonths]
        dateList.append(firstDict)
        
        
        // 添加中间月份
        let firstYearInt = firstYear.int ?? 1000
        let currentYearInt = currentDateYear.int ?? 1001
        let offset = (currentYearInt - firstYearInt)
        if offset > 1 {
            
            for i in 1..<offset {
                let year = firstYearInt + i
                let yearStr = year.string
                var months: [String] = []
                months = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
                let dict: [String : Any] = ["year": yearStr, "month" : months]
                dateList.append(dict)
            }
        }
        // 添加最后
        var lastMonths: [String] = []
        for i in 0...currentMonthInt {
            lastMonths.append(i.string)
        }
        let lastDict: [String : Any] = ["year":currentDateYear, "month" : lastMonths]
        dateList.append(lastDict)
        
        debugPrint("dateList: \(dateList)")
        
    }
    
    func fetchTotalPrice(beginTime: Date, endTime: Date, completion: @escaping ((String)->Void)) {
        MNDBManager.default.selectMoneyNoteItem(beginTime: beginTime, endTime: endTime, "priceStr") { insightPaihangList in
            debugPrint("insightPaihangList = \(insightPaihangList)")
            var priceTotal: Double = 0
            
            for item in insightPaihangList {
                priceTotal += (item.priceStr.double() ?? 0)
            }
            priceTotal = priceTotal.roundTo(places: 2)
            var priceStr = "\(priceTotal)"
            if priceStr.contains(".") {
                let strings = priceStr.components(separatedBy: ".")
                let lastStr = strings.last
                if let lastStrInt = lastStr?.int, lastStrInt > 0 {
                    //带有小数
                } else {
                    priceStr = strings.first ?? priceStr
                }
            }
            completion(priceStr)
        }
    }
    
    func fetchGouCheng(beginTime: Date, endTime: Date, completion: @escaping (([MNkbsInsightItem])->Void)) {
        MNDBManager.default.selectMoneyNoteItem(beginTime: beginTime, endTime: endTime) { noteList in
            //
            var insightItems: [MNkbsInsightItem] = []
            var maxPrice: Double = 0
            
            noteList.forEach {
                
                let price = $0.priceStr.double() ?? 0
                
                for tagItem in $0.tagModelList {
                    let tagName = tagItem.tagName
                    let insightItem_s = insightItems.first {
                        $0.tagName == tagName
                    }
                    var item = MNkbsInsightItem()
                    item.tagName = tagName
                    if let insightItem_s_m = insightItem_s {
                        item.priceDouble = insightItem_s_m.priceDouble + price
                        insightItems.removeFirst {
                            $0.tagName == tagName
                        }
                    } else {
                        item.priceDouble = price
                    }
                    
                    maxPrice = (item.priceDouble > maxPrice) ? item.priceDouble : maxPrice
                    
                    insightItems.append(item)
                }
            }
            
            var insightItems_m: [MNkbsInsightItem] = []
             
            for insightItem in insightItems {
                var item = MNkbsInsightItem()
                item.tagName = insightItem.tagName
                item.priceDouble = insightItem.priceDouble
                
                item.percentLine = (insightItem.priceDouble / maxPrice).roundTo(places: 2)
                insightItems_m.append(item)
            }
            self.currentGouChengList = insightItems_m
            completion(insightItems_m)
        }
        
    }
    
    func fetchPaiHang(beginTime: Date, endTime: Date, completion: @escaping (([MoneyNoteModel])->Void)) {
        MNDBManager.default.selectMoneyNoteItem(beginTime: beginTime, endTime: endTime, "priceStr") { insightPaihangList in
            debugPrint("insightPaihangList = \(insightPaihangList)")
            self.currentPaiHangList = insightPaihangList
            completion(insightPaihangList)
        }
    }
    
    func processBeginDateAndEndDate(dateMonthString: String) -> (Date, Date, Int) {
        // beginDate, endDate, numberOfDaysInMonth
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let currentDate = formatter.date(from: "\(dateMonthString)-01-01-01-01") ?? Date()
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)
        let numberOfDaysInMonth = range?.count ?? 0
        debugPrint("\(numberOfDaysInMonth)")
        
        let beginDate = formatter.date(from: "\(dateMonthString)-01-00-00-00") ?? Date()
        let endDate = formatter.date(from: "\(dateMonthString)-\(numberOfDaysInMonth)-23-59-59") ?? Date()
        return(beginDate, endDate, numberOfDaysInMonth)
    }
    
    func processMoneyNoteItemRecordTimeToString(noteItemRecordDate: String) -> String {
        let timestamp = noteItemRecordDate
        let dou = Double(timestamp) ?? 0
        let timeInterStr = String(dou / 1000)
        if let interval = TimeInterval.init(timeInterStr) {
            let recordDate = Date(timeIntervalSince1970: interval)
            let dayformatter = DateFormatter()
            dayformatter.dateFormat = "yyyy-MM-dd"
            let dateString = dayformatter.string(from: recordDate)
            return dateString
        } else {
            return ""
        }
    }
    
    func fetchInsightDaysMoney(dateMonthString: String, completion: @escaping (([MNkbsInsightChartMonthItem])->Void)) {
//       dateMonthString = "2017-07"
        
        var maxNumberOfDays: Int = 1
        
        let (beginDate, endDate, numberOfDaysInMonth) = processBeginDateAndEndDate(dateMonthString: dateMonthString)
        
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let nowMonthString = formatter.string(from: Date())
        formatter.dateFormat = "dd"
        let nowDayString = formatter.string(from: Date())
        if dateMonthString.contains("-\(nowMonthString)") {
            // 当前月
            maxNumberOfDays = nowDayString.int ?? 1
        } else {
            maxNumberOfDays = numberOfDaysInMonth
        }
        
        var dateStrList: [String] = []
        for i in 1...maxNumberOfDays {
            if i <= 9 {
                let stri = "\(dateMonthString)-0\(i)"
                dateStrList.append(stri)
            } else {
                let stri = "\(dateMonthString)-\(i)"
                dateStrList.append(stri)
            }
        }
        
        MNDBManager.default.selectMoneyNoteItem(beginTime: beginDate, endTime: endDate) { [weak self] list in
            guard let `self` = self else {return}
            var resultChartItemList: [MNkbsInsightChartMonthItem] = []
            
            for xDateStr in dateStrList {
                let currentNoteList: [MoneyNoteModel] = []
                let item = MNkbsInsightChartMonthItem(xInfoStr: xDateStr, yNoteItem: currentNoteList)
                resultChartItemList.append(item)
            }
            
            for noteItem in list {
                let dateString = self.processMoneyNoteItemRecordTimeToString(noteItemRecordDate: noteItem.recordDate)
                let charrItem = resultChartItemList.first {
                    $0.xInfoStr == dateString
                }
                charrItem?.yNoteItem.append(noteItem)

            }
            completion(resultChartItemList)
        }
    }
    
    func fetchInsightMonthsMoney(dateYearString: String, completion: @escaping (([MNkbsInsightChartYearItem])->Void)) {
        // dateYearString = "2000"
        
        var monthList: [MNkbsInsightChartYearItem] = []
        var maxNumberOfDays = 12
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let nowYearString = formatter.string(from: Date())
        
        if dateYearString.contains(nowYearString) {
            formatter.dateFormat = "MM"
            let nowMonthString = formatter.string(from: Date())
            maxNumberOfDays = nowMonthString.int ?? maxNumberOfDays
        }
        
        for i in 1...maxNumberOfDays {
            
            var dateMonthString = "\(dateYearString)-\(i)"
            var monthStri = "\(dateYearString)-\(i)-01-00-00-01"
            if i <= 9 {
                dateMonthString = "\(dateYearString)-0\(i)"
                monthStri = "\(dateYearString)-0\(i)-01-00-00-01"
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            
            let currentDate = formatter.date(from: monthStri) ?? Date()
            
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: currentDate)
            let numberOfDaysInMonth = range?.count ?? 0
            debugPrint("\(numberOfDaysInMonth)")
            
            let beginDate = formatter.date(from: "\(dateMonthString)-01-00-00-00") ?? Date()
            let endDate = formatter.date(from: "\(dateMonthString)-\(numberOfDaysInMonth)-23-59-59") ?? Date()
            
            
            
            MNDBManager.default.selectMoneyNoteItem(beginTime: beginDate, endTime: endDate) { list in
                
                var price: Double = 0
                for item in list {
                    price += (item.priceStr.double() ?? 0)
                }
                debugPrint("dateMonthString: \(dateMonthString) price: \(price)")
                
                let yearMonthItem = MNkbsInsightChartYearItem(xInfoStr: dateMonthString, yNoteItem: price)
                
                monthList.append(yearMonthItem)   
            }
        }
        debugPrint("monthList = \(monthList)")
        completion(monthList)
    }
    
}

 
