//
//  UIView+Extension.swift
//  Example
//
//  Created by QuintGao on 2022/3/21.
//  Copyright © 2022 QuintGao. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

extension UIView {
    // 渐变色转图片
    func image(with colors: [Any]) -> UIImage? {
        addGradualLayer(colors)
        return convertToImage()
    }
    
    func addGradualLayer(_ colors: [Any]) {
        if colors.count == 0 { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.02, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    func convertToImage() -> UIImage? {
        let size = self.bounds.size
        if size.width <= 0 || size.height <= 0 { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 获取当前视图所在的最顶层 UIViewController
    var topMostViewController: UIViewController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let vc = next as? UIViewController {
                return vc
            }
            responder = next
        }
        return nil
    }
}

extension UIApplication {
    /// 获取顶层可用的 window（适配 iOS 13+ 和多场景）
    static var topKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    /// 获取当前 App 最顶层可见的 UIViewController
    var topMostViewController: UIViewController? {
        var topVC = self.windows.first { $0.isKeyWindow }?.rootViewController
        while let presentedVC = topVC?.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
}
