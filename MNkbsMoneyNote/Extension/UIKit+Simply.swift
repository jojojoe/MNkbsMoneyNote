//
//  MNkbsExtensionTool.swift
//  MNkbsMoneyNote
//
//  Created by JOJO on 2021/7/28.
//

import Foundation
import UIKit
import SwifterSwift

public extension UIView {
    @discardableResult
    func crop() -> Self {
        contentMode()
        clipsToBounds()
        return self
    }

    @discardableResult
    func alpha(_ value: CGFloat) -> Self {
        alpha = value
        return self
    }

    @discardableResult
    func hidden(_ value: Bool = true) -> Self {
        isHidden = value
        return self
    }
    
    @discardableResult
    func show(_ value: Bool = true) -> Self {
        isHidden = !value
        return self
    }

    @discardableResult
    func cornerRadius(_ value: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = value
        layer.masksToBounds = masksToBounds
        return self
    }

    @discardableResult
    func borderColor(_ value: UIColor, width: CGFloat = UIScreen.minLineWidth) -> Self {
        layer.borderColor = value.cgColor
        layer.borderWidth = width
        return self
    }

    @discardableResult
    func contentMode(_ value: UIView.ContentMode = .scaleAspectFill) -> Self {
        contentMode = value
        return self
    }

    @discardableResult
    func clipsToBounds(_ value: Bool = true) -> Self {
        clipsToBounds = value
        return self
    }

    @discardableResult
    func tag(_ value: Int) -> Self {
        tag = value
        return self
    }

    @discardableResult
    func tintColor(_ value: UIColor) -> Self {
        tintColor = value
        return self
    }

    @discardableResult
    func backgroundColor(_ value: UIColor) -> Self {
        backgroundColor = value
        return self
    }

    @discardableResult
    func isUserInteractionEnabled(_ value: Bool = true) -> Self {
        isUserInteractionEnabled = value
        return self
    }
}

public extension UIFont {
    enum FontNames: String {
        case AvenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
        case AvenirNextDemiBold = "AvenirNext-DemiBold "
        case AvenirNextBold = "AvenirNext-Bold"
        case AvenirHeavy = "Avenir-Heavy"
        case AvenirMedium = "Avenir-Medium"
        case GillSans
        case GillSansSemiBold = "GillSans-SemiBold"
        case GillSansSemiBoldItalic = "GillSans-SemiBoldItalic"
        case GillSansBold = "GillSans-Bold"
        case GillSansBoldItalic = "GillSans-BoldItalic"
        case MontserratMedium = "Montserrat-Medium"
        case MontserratSemiBold = "Montserrat-SemiBold"
        case MontserratBold = "Montserrat-Bold"
        case MontserratRegular = "Montserrat-Regular"
    }

    static func custom(_ value: CGFloat, name: FontNames) -> UIFont {
        return UIFont(name: name.rawValue, size: value) ?? UIFont.systemFont(ofSize: value)
    }
}

public extension UILabel {
    @discardableResult
    func text(_ value: String?) -> Self {
        text = value
        return self
    }

    @discardableResult
    func color(_ value: UIColor) -> Self {
        textColor = value
        return self
    }

    @discardableResult
    func font(_ value: CGFloat, _ bold: Bool = false) -> Self {
        font = bold ? UIFont.boldSystemFont(ofSize: value) : UIFont.systemFont(ofSize: value)
        return self
    }

    @discardableResult
    func font(_ value: CGFloat, _ name: UIFont.FontNames) -> Self {
        font = UIFont(name: name.rawValue, size: value)
        return self
    }
    
    func fontName(_ value: CGFloat, _ name: String) -> Self {
        font = UIFont(name: name, size: value)
        return self
    }
    
    @discardableResult
    func numberOfLines(_ value: Int = 0) -> Self {
        numberOfLines = value
        return self
    }

    @discardableResult
    func textAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }

    @discardableResult
    func lineBreakMode(_ value: NSLineBreakMode = .byTruncatingTail) -> Self {
        lineBreakMode = value
        return self
    }
}

public extension UIButton {
    @discardableResult
    func title(_ value: String?, _ state: UIControl.State = .normal) -> Self {
        setTitle(value, for: state)
        return self
    }

    @discardableResult
    func titleColor(_ value: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(value, for: state)
        return self
    }

    @discardableResult
    func image(_ value: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(value, for: state)
        return self
    }

    @discardableResult
    func backgroundImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(value, for: state)
        return self
    }

    @discardableResult
    func backgroundColor(_ value: UIColor, _ state: UIControl.State = .normal) -> Self {
        setBackgroundColor(value, for: state)
        return self
    }

    @discardableResult
    func font(_ value: CGFloat, _ bold: Bool = false) -> Self {
        titleLabel?.font(value, bold)
        return self
    }

    @discardableResult
    func font(_ value: CGFloat, _ nameStr: String) -> Self {
        titleLabel?.fontName(value, nameStr)
        return self
    }
    
    @discardableResult
    func font(_ value: CGFloat, _ name: UIFont.FontNames) -> Self {
        titleLabel?.font(value, name)
        return self
    }

    @discardableResult
    func lineBreakMode(_ value: NSLineBreakMode = .byTruncatingTail) -> Self {
        titleLabel?.lineBreakMode(value)
        return self
    }

    @discardableResult
    func isEnabled(_ value: Bool = false) -> Self {
        isEnabled = value
        return self
    }

    @discardableResult
    func showsTouch(_ value: Bool = true) -> Self {
        showsTouchWhenHighlighted = value
        return self
    }
}

public extension UIImageView {
    @discardableResult
    func image(_ value: String?, _: Bool = false) -> Self {
        guard let value = value else { return self }
        image = UIImage(named: value) ?? UIImage.named(value)
        return self
    }
}

protocol UIViewLoading {}

/// Extend UIView to declare that it includes nib loading functionality
extension UIView: UIViewLoading {}

/// Protocol implementation
extension UIViewLoading where Self: UIView {
    static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        let nibName = nibNameOrNil ?? className
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}

extension UIApplication {
    @objc
    public static var rootController: UIViewController? {
        return shared.keyWindow?.rootViewController
    }
}

public extension Color {
    static func hexString(_ value: String) -> Color {
        return Color(hexString: value) ?? .white
    }
}

public extension UIImage {
    static func named(_ value: String?) -> UIImage? {
        guard let value = value else { return nil }
        return UIImage(named: value) ?? UIImage(namedInBundle: value)
    }

    convenience init?(namedInBundle name: String) {
        let path = Bundle.main.path(forResource: "BachCore", ofType: "bundle") ?? ""
        self.init(named: name, in: Bundle(path: path), compatibleWith: nil)
    }
    
    func original() -> UIImage {
        return self.original
    }
    
}

public extension UIView {
    var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return .zero
        }
    }

    @discardableResult
    func gradientBackground(_ colorOne: UIColor, _ colorTwo: UIColor,
                            startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                            endPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)) -> CAGradientLayer {
        
        let gradient = layer.sublayers?.filter { $0 is CAGradientLayer }.first as? CAGradientLayer
        
        if let gradient = gradient {
            gradient.frame = bounds
            return gradient
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
//        layer.addSublayer(gradientLayer)
        return gradientLayer
    }
}

public extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

public extension UIScreen {
    static var minLineWidth: CGFloat {
        return 1 / UIScreen.main.scale
    }
}

public extension UIImage {
    static func with(
        color: UIColor,
        size: CGSize = CGSize(sideLength: 1),
        opaque: Bool = false,
        scale: CGFloat = 0
    ) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func tinted(with color: UIColor, opaque: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, opaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }

        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.cgImage
        else { return nil }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)

        let rect = CGRect(origin: .zero, size: size)

        context.setBlendMode(.normal)
        context.draw(cgImage, in: rect)

        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        setBackgroundImage(UIImage.with(color: color), for: state)
    }
}

public extension CGSize {
    init(sideLength: Int) {
        self.init(width: sideLength, height: sideLength)
    }

    init(sideLength: Double) {
        self.init(width: sideLength, height: sideLength)
    }

    init(sideLength: CGFloat) {
        self.init(width: sideLength, height: sideLength)
    }

    var longSide: CGFloat {
        return max(width, height)
    }

    var shortSide: CGFloat {
        return min(width, height)
    }
}

public typealias ButtonActionBlock = (UIButton) -> Void

var ActionBlockKey: UInt8 = 02

private class ActionBlockWrapper: NSObject {
    let block: ButtonActionBlock

    init(block: @escaping ButtonActionBlock) {
        self.block = block
    }
}

public extension Int {
    func k() -> String {
        if self >= 1000 {
            var sign: String {
                return self >= 0 ? "" : "-"
            }
            let abs = Swift.abs(self)
            if abs >= 1000, abs < 1_000_000 {
                return String(format: "\(sign)%.1fK", abs.double / 1000.0)
            }
            return String(format: "\(sign)%.1fM", abs.double / 1_000_000.0)
        }
        return string
    }
}

public extension UIDevice {
    static var isPad: Bool {
        return current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        return current.userInterfaceIdiom == .phone
    }
}

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}


public protocol ViewChainable {}

public extension ViewChainable where Self: AnyObject {
    @discardableResult
    func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }

    @discardableResult
    func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}

public func debugOnly(_ action: () -> Void) {
    assert(
        {
            action()
            return true
        }()
    )
}

extension UIView: ViewChainable {
    @discardableResult
    public func config(cornerRadius: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds

        return self
    }

    @discardableResult
    public func configBorder(color: UIColor, width: CGFloat? = nil) -> Self {
        layer.borderColor = color.cgColor
        if let borderWidth = width {
            layer.borderWidth = borderWidth
        }

        return self
    }

    @discardableResult
    public func configShadow(
        color: UIColor?,
        radius: CGFloat? = nil,
        opacity: Float? = nil,
        offset: CGSize? = nil,
        path: CGPath? = nil
    ) -> Self {
        layer.shadowColor = color?.cgColor

        if let radius = radius {
            layer.shadowRadius = radius
        }

        if let opacity = opacity {
            layer.shadowOpacity = opacity
        }

        if let offset = offset {
            layer.shadowOffset = offset
        }

        if let path = path {
            layer.shadowPath = path
        }

        return self
    }

    @discardableResult
    public func adhere(toSuperview superview: UIView) -> Self {
        superview.addSubview(self)
        return self
    }

    @discardableResult
    public func adhere(toSuperview superview: UIView, below siblingView: UIView) -> Self {
        superview.insertSubview(self, belowSubview: siblingView)
        return self
    }

    @discardableResult
    public func adhere(toSuperview superview: UIView, above siblingView: UIView) -> Self {
        superview.insertSubview(self, aboveSubview: siblingView)
        return self
    }

    @discardableResult
    public func layout(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    @discardableResult
    public func layout(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        var newFrame = frame

        if let x = x {
            newFrame.origin.x = x
        }
        if let y = y {
            newFrame.origin.y = y
        }
        if let width = width {
            newFrame.size.width = width
        }
        if let height = height {
            newFrame.size.height = height
        }

        return layout(newFrame)
    }
}
