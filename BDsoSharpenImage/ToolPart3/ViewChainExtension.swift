//
//  ViewChainExtension.swift
//  BDsoSharpenImage
//
//  Created by JOJO on 2023/7/4.
//

import Foundation
import UIKit
import SnapKit
import SwifterSwift
import DeviceKit

extension UIFont {
    static let FontName_PoppinsLight = "Poppins"
    static let FontName_PoppinsRegular = "Poppins"
    static let FontName_PoppinsMedium = "Poppins"
    static let FontName_PoppinsSemiBold = "Poppins"
    static let FontName_PoppinsBold = "Poppins"
}

extension UIScreen {
    
    static func width() -> CGFloat {
        return self.main.bounds.size.width
    }
    
    static func height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
    static func isDevice8SE() -> Bool {
        if Device.current.diagonal <= 4.7 {
            return true
        }
        return false
    }
    
    static func isDevice8SEPaid() -> Bool {
        if Device.current.diagonal <= 4.7 || Device.current.diagonal >= 7.0 {
            return true
        }
        return false
    }
    
    static func isDevice8Plus() -> Bool {
        if Device.current.diagonal == 5.5 {
            return true
        }
        return false
    }
    
    
}
extension Double {
   func roundTo(places:Int) -> Double {
       let divisor = pow(10.0, Double(places))
       return (self * divisor).rounded() / divisor

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

public extension UIView {
    
    @discardableResult
    public func adhere(toSuperview superview: UIView, _ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        superview.addSubview(self)
        self.snp.makeConstraints(closure)
        return self
    }
    
    @discardableResult
    func shadow (
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
    func crop() -> Self {
        contentMode()
        clipsToBounds()
        return self
    }

    @discardableResult
    func cornerRadius(_ value: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = value
        layer.masksToBounds = masksToBounds
        return self
    }

    @discardableResult
    func borderColor(_ value: UIColor, width: CGFloat = 1) -> Self {
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
}


public extension UIImageView {
    @discardableResult
    func image(_ value: String?, _: Bool = false) -> Self {
        guard let value = value else { return self }
        image = UIImage(named: value)
        return self
    }
    
    @discardableResult
    func highlightedImage(_ value: String?, _: Bool = false) -> Self {
        guard let value = value else { return self }
        highlightedImage = UIImage(named: value)
        return self
    }
    
    @discardableResult
    func image(_ valueImg: UIImage?) -> Self {
        guard let valueImg = valueImg else { return self }
        image = valueImg
        return self
    }
    
    @discardableResult
    func isHighlighted(_ value: Bool = false) -> Self {
        isHighlighted = value
        return self
    }
}

extension UILabel {
    @discardableResult
    public func text(_ value: String?) -> Self {
        text = value
        return self
    }

    @discardableResult
    public func color(_ value: UIColor) -> Self {
        textColor = value
        return self
    }

    @discardableResult
    public func font(_ name: String, _ value: CGFloat) -> Self {
        font = UIFont(name: name, size: value) ?? UIFont.systemFont(ofSize: value)
        return self
    }

    @discardableResult
    public func numberOfLines(_ value: Int) -> Self {
        numberOfLines = value
        return self
    }

    @discardableResult
    public func textAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }

    @discardableResult
    public func lineBreakMode(_ value: NSLineBreakMode = .byTruncatingTail) -> Self {
        lineBreakMode = value
        return self
    }
    
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ value: Bool = true) -> Self {
        adjustsFontSizeToFitWidth = value
        return self
    }
    
    
}

extension UIButton {
    @discardableResult
    public func title(_ value: String?, _ state: UIControl.State = .normal) -> Self {
        setTitle(value, for: state)
        return self
    }

    @discardableResult
    public func titleColor(_ value: UIColor, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(value, for: state)
        return self
    }

    @discardableResult
    public func image(_ value: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setImage(value, for: state)
        return self
    }

    @discardableResult
    public func backgroundImage(_ value: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(value, for: state)
        return self
    }

    @discardableResult
    public func backgroundColor(_ value: UIColor, size: CGSize, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(UIImage(color: value, size: size), for: state)
        return self
    }
    
    @discardableResult
    public func font(_ name: String, _ value: CGFloat) -> Self {
        titleLabel?.font(name, value)
        return self
    }
    
    @discardableResult
    public func lineBreakMode(_ value: NSLineBreakMode = .byTruncatingTail) -> Self {
        titleLabel?.lineBreakMode(value)

        return self
    }
    
    @discardableResult
    public func target(target: Any?, action: Selector, event: UIControl.Event) -> Self {
        self.addTarget(target, action: action, for: event)
        return self
    }
    
    @discardableResult
    func isEnabled(_ value: Bool = false) -> Self {
        isEnabled = value
        return self
    }
    
    @discardableResult
    func isSelected(_ value: Bool = false) -> Self {
        isSelected = value
        return self
    }
    
}





