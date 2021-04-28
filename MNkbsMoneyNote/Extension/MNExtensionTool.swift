//
//  MNExtensionTool.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/8.
//

import Foundation
import UIKit

extension UITextView {
    
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil { // 不存在是 创建 绑定
                if (self.font == nil) { // 防止没大小时显示异常 系统默认设置14
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = self.font
                label?.textColor = UIColor.lightGray
                label?.textAlignment = self.textAlignment
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            } else {
                label?.font = self.font
                label?.textColor = label?.textColor.withAlphaComponent(0.6)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


public class Once {
    var already: Bool = false

    public init() {}

    public func run(_ block: () -> Void) {
        guard !already else {
            return
        }

        block()
        already = true
    }
}



extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        let dayName = weekDay.rawValue
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        assert(weekdaysName.contains(dayName),"weekday symbol should be in form (weekdaysName)")
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        let calendar = Calendar(identifier:. gregorian)
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy:. nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
}


extension Date {
    //本月开始日期
    func startOfCurrentMonth() -> Date {
        let date = self
        let calendar = Calendar(identifier:. gregorian)
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: date)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
     
    //本月结束日期
    func endOfCurrentMonth(returnEndTime:Bool = true) -> Date {
        let calendar = Calendar(identifier:. gregorian)
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
         
        let endOfMonth =  calendar.date(byAdding: components, to: startOfCurrentMonth())!
        return endOfMonth
    }
    //本年开始日期
    func startOfCurrentYear() -> Date {
        let date = self
        let calendar = Calendar(identifier:. gregorian)
        let components = calendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
        let startOfYear = calendar.date(from: components)!
        return startOfYear
    }
     
    //本年结束日期
    func endOfCurrentYear(returnEndTime:Bool = true) -> Date {
        let calendar = Calendar(identifier:. gregorian)
        var components = DateComponents()
        components.year = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
         
        let endOfYear = calendar.date(byAdding: components, to: startOfCurrentYear())!
        return endOfYear
    }
}


//MARK: Helper methods


extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier:. gregorian)
        calendar.locale = Locale(identifier:"en_US_POSIX")
        return calendar.weekdaySymbols
    }
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}

