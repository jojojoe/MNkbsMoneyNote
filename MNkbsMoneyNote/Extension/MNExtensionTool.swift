//
//  MNExtensionTool.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/4/8.
//

import Foundation
import UIKit
import Alertift
import ZKProgressHUD


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

public extension UIApplication {
    @discardableResult
    func openURL(url: URL) -> Bool {
        guard UIApplication.shared.canOpenURL(url) else { return false }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    }

    @discardableResult
    func openURL(url: String?) -> Bool {
        guard let str = url, let url = URL(string: str) else { return false }
        return openURL(url: url)
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

extension Double {

    /// Rounds the double to decimal places value

    func roundTo(places:Int) -> Double {

        let divisor = pow(10.0, Double(places))

        return (self * divisor).rounded() / divisor

    }

}



public struct HUD {
    public static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }

    public static func hide() {
        ZKProgressHUD.dismiss()
    }

    
    public static func error(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showError(value, autoDismissDelay: 2.0)
    }

    public static func success(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showSuccess(value, autoDismissDelay: 2.0)
    }
    
    public static func progress(_ value: CGFloat?) {
        ZKProgressHUD.showProgress(value)
    }
    
    public static func progress(_ value: CGFloat?, status: String? = nil) {
        ZKProgressHUD.showProgress(value, status: status, onlyOnceFont: UIFont(name: FONT_AvenirMedium, size: 14))
        
        
    }
    
}

public struct Alert {
    public static func error(_ value: String?, title: String? = "Error", success: (() -> Void)? = nil) {
        if UIApplication.rootController?.visibleVC is UIAlertController {
            return
        }
        HUD.hide()
        Alertift
            .alert(title: title, message: value)
            .action(.cancel("OK"), handler: { _, _, _ in
                success?()
//                AppDelegate.alertShow = false
            })
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
    }

    public static func message(_ value: String?, success: (() -> Void)? = nil) {
        if UIApplication.rootController?.visibleVC is UIAlertController {
            return
        }
        HUD.hide()
        Alertift
            .alert(message: value)
            .action(.cancel("OK"), handler: { _, _, _ in
                success?()
//                AppDelegate.alertShow = false
            })
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
    }
}

@objc
public class HUDClass: NSObject {
    @objc
    public static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }

    @objc
    public static func hide() {
        ZKProgressHUD.dismiss()
    }
}

public extension UIViewController {
    
    static func topVC() -> UIViewController? {
        if let rootvc = UIApplication.shared.windows.first?.rootViewController {
            return rootvc.topMost(of: rootvc)
        }
        return nil
    }
    
    @objc
    var rootVC: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    @objc
    var visibleVC: UIViewController? {
        return topMost(of: rootVC)
    }
 

    var visibleTabBarController: UITabBarController? {
        return topMost(of: rootVC)?.tabBarController
    }

    var visibleNavigationController: UINavigationController? {
        return topMost(of: rootVC)?.navigationController
    }

    private func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        return viewController
    }

    func present(_ controller: UIViewController, _: Bool = false) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true, completion: nil)
    }

    func presentDissolve(_ controller: UIViewController,
                         animated: Bool = true,
                         completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: animated, completion: completion)
    }

    func presentFullScreen(_ controller: UIViewController,
                           animated: Bool = true,
                           completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: animated, completion: completion)
    }
}



extension Timer {
    // MARK: Schedule timers

    /// Create and schedule a timer that will call `block` once after the specified time.

    @discardableResult
    public class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, block)
        timer.start()
        return timer
    }

    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.

    @discardableResult
    public class func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }

    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)

    @nonobjc @discardableResult
    public class func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }

    // MARK: Create timers without scheduling

    /// Create a timer that will call `block` once after the specified time.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.after` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)

    public class func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }

    /// Create a timer that will call `block` repeatedly in specified time intervals.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)

    public class func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }

    /// Create a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)

    @nonobjc public class func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }

    // MARK: Manual scheduling

    /// Schedule this timer on the run loop
    ///
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.

    public func start(runLoop: RunLoop = .current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [.default] : modes

        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
}

// MARK: - Time extensions

extension Double {
    public var millisecond: TimeInterval { return self / 1000 }
    public var milliseconds: TimeInterval { return self / 1000 }
    public var ms: TimeInterval { return self / 1000 }

    public var second: TimeInterval { return self }
    public var seconds: TimeInterval { return self }

    public var minute: TimeInterval { return self * 60 }
    public var minutes: TimeInterval { return self * 60 }

    public var hour: TimeInterval { return self * 3600 }
    public var hours: TimeInterval { return self * 3600 }

    public var day: TimeInterval { return self * 3600 * 24 }
    public var days: TimeInterval { return self * 3600 * 24 }
}
