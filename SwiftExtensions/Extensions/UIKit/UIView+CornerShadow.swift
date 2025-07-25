//
//  UIView+CornerShadow.swift
//  tongshengbao_cn
//
//  Created by AI for chainable corner/shadow/border extension.
//

import UIKit

public extension UIView {
    @discardableResult
    func setCornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask? = nil) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        if let corners = maskedCorners {
            if #available(iOS 11.0, *) {
                layer.maskedCorners = corners
            }
        }
        return self
    }
    @discardableResult
    func setBorder(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    @discardableResult
    func setShadow(color: UIColor = .black, offset: CGSize = .zero, radius: CGFloat = 4, opacity: Float = 0.15, path: UIBezierPath? = nil) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        if let path = path {
            layer.shadowPath = path.cgPath
        }
        return self
    }
    @discardableResult
    func removeShadow() -> Self {
        layer.shadowOpacity = 0
        layer.shadowPath = nil
        return self
    }
}

public extension CALayer {
    @discardableResult
    func setCornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask? = nil) -> Self {
        cornerRadius = radius
        masksToBounds = true
        if let corners = maskedCorners {
            if #available(iOS 11.0, *) {
                self.maskedCorners = corners
            }
        }
        return self
    }
    @discardableResult
    func setBorder(width: CGFloat, color: UIColor) -> Self {
        borderWidth = width
        borderColor = color.cgColor
        return self
    }
    @discardableResult
    func setShadow(color: UIColor = .black, offset: CGSize = .zero, radius: CGFloat = 4, opacity: Float = 0.15, path: UIBezierPath? = nil) -> Self {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
        masksToBounds = false
        if let path = path {
            shadowPath = path.cgPath
        }
        return self
    }
    @discardableResult
    func removeShadow() -> Self {
        shadowOpacity = 0
        shadowPath = nil
        return self
    }
} 