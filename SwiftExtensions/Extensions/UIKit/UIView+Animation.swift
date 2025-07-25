//
//  UIView+Animation.swift
//  tongshengbao_cn
//
//  Created by AI for UIView/CAAnimation animation convenience extensions.
//

import UIKit

public extension UIView {
    /// 链式淡入动画
    @discardableResult
    func fadeIn(duration: TimeInterval = 0.25, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) -> Self {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1
        }, completion: completion)
        return self
    }
    /// 链式淡出动画
    @discardableResult
    func fadeOut(duration: TimeInterval = 0.25, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) -> Self {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.isHidden = true
            completion?(finished)
        })
        return self
    }
    /// 链式缩放动画
    @discardableResult
    func scale(from: CGFloat = 0.8, to: CGFloat = 1.0, duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) -> Self {
        transform = CGAffineTransform(scaleX: from, y: from)
        isHidden = false
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: to, y: to)
        }, completion: completion)
        return self
    }
    /// 链式旋转动画
    @discardableResult
    func rotate(by angle: CGFloat, duration: TimeInterval = 0.25, completion: ((Bool) -> Void)? = nil) -> Self {
        UIView.animate(withDuration: duration, animations: {
            self.transform = self.transform.rotated(by: angle)
        }, completion: completion)
        return self
    }
    /// 弹性动画
    @discardableResult
    func spring(duration: TimeInterval = 0.5, damping: CGFloat = 0.6, velocity: CGFloat = 0.8, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) -> Self {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseInOut, animations: animations, completion: completion)
        return self
    }
    /// 渐变动画
    @discardableResult
    func animateGradient(colors: [UIColor], duration: TimeInterval = 0.5) -> Self {
        guard let gradientLayer = layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first else { return self }
        let fromColors = gradientLayer.colors
        let toColors = colors.map { $0.cgColor }
        gradientLayer.colors = toColors
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradientLayer.add(animation, forKey: "colors")
        return self
    }
}

public extension CALayer {
    /// 便捷添加淡入淡出动画
    func addFade(duration: TimeInterval = 0.25) {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = duration
        add(animation, forKey: "fade")
    }
    /// 便捷添加缩放动画
    func addScale(from: CGFloat = 0.8, to: CGFloat = 1.0, duration: TimeInterval = 0.25) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        add(animation, forKey: "scale")
    }
    /// 便捷添加旋转动画
    func addRotation(by angle: CGFloat, duration: TimeInterval = 0.25) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.byValue = angle
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        add(animation, forKey: "rotation")
    }
} 