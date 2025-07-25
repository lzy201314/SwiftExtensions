//
//  UIBezierPath+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIBezierPath+YYAdd.
//

import UIKit

extension UIBezierPath {
    /// 便捷创建圆角矩形路径
    static func roundedRect(_ rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
    }
    /// 便捷创建椭圆路径
    static func oval(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: rect)
    }
    /// 便捷创建圆形路径
    static func circle(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    }
    /// 便捷创建线段路径
    static func line(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
} 