//
//  UIView+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIView+YYAdd.
//

import UIKit

extension UIView {
    // MARK: - Snapshot
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        if let ctx = UIGraphicsGetCurrentContext() {
            layer.render(in: ctx)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
    func snapshotImage(afterScreenUpdates: Bool) -> UIImage? {
        if responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
            defer { UIGraphicsEndImageContext() }
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
            return UIGraphicsGetImageFromCurrentImageContext()
        } else {
            return snapshotImage()
        }
    }
    func snapshotPDF() -> Data? {
        let bounds = self.bounds
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData),
              let context = CGContext(consumer: consumer, mediaBox: &self.bounds, nil) else { return nil }
        context.beginPDFPage(nil)
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        layer.render(in: context)
        context.endPDFPage()
        context.closePDF()
        return data as Data
    }
    // MARK: - Layer Shadow
    func setLayerShadow(color: UIColor?, offset: CGSize, radius: CGFloat) {
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    // MARK: - Subviews
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    // MARK: - View Controller
    var viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let vc = responder as? UIViewController { return vc }
            nextResponder = responder.next
        }
        return nil
    }
    // MARK: - Visible Alpha
    var visibleAlpha: CGFloat {
        if let window = self as? UIWindow {
            return window.isHidden ? 0 : window.alpha
        }
        guard window != nil else { return 0 }
        var alpha: CGFloat = 1
        var v: UIView? = self
        while let view = v {
            if view.isHidden { alpha = 0; break }
            alpha *= view.alpha
            v = view.superview
        }
        return alpha
    }
    // MARK: - Coordinate Convert
    func convert(point: CGPoint, toViewOrWindow view: UIView?) -> CGPoint {
        if let view = view {
            let from = (self is UIWindow) ? self : self.window
            let to = (view is UIWindow) ? view : view.window
            if from == nil || to == nil || from == to {
                return convert(point, to: view)
            }
            var pt = convert(point, to: from)
            pt = to!.convert(pt, from: from)
            return view.convert(pt, from: to)
        } else {
            if self is UIWindow {
                return (self as! UIWindow).convert(point, to: nil)
            } else {
                return convert(point, to: nil)
            }
        }
    }
    func convert(point: CGPoint, fromViewOrWindow view: UIView?) -> CGPoint {
        if let view = view {
            let from = (view is UIWindow) ? view : view.window
            let to = (self is UIWindow) ? self : self.window
            if from == nil || to == nil || from == to {
                return convert(point, from: view)
            }
            var pt = from!.convert(point, from: view)
            pt = to!.convert(pt, from: from)
            return convert(pt, from: to)
        } else {
            if self is UIWindow {
                return (self as! UIWindow).convert(point, from: nil)
            } else {
                return convert(point, from: nil)
            }
        }
    }
    func convert(rect: CGRect, toViewOrWindow view: UIView?) -> CGRect {
        if let view = view {
            let from = (self is UIWindow) ? self : self.window
            let to = (view is UIWindow) ? view : view.window
            if from == nil || to == nil || from == to {
                return convert(rect, to: view)
            }
            var r = convert(rect, to: from)
            r = to!.convert(r, from: from)
            return view.convert(r, from: to)
        } else {
            if self is UIWindow {
                return (self as! UIWindow).convert(rect, to: nil)
            } else {
                return convert(rect, to: nil)
            }
        }
    }
    func convert(rect: CGRect, fromViewOrWindow view: UIView?) -> CGRect {
        if let view = view {
            let from = (view is UIWindow) ? view : view.window
            let to = (self is UIWindow) ? self : self.window
            if from == nil || to == nil || from == to {
                return convert(rect, from: view)
            }
            var r = from!.convert(rect, from: view)
            r = to!.convert(r, from: from)
            return convert(r, from: to)
        } else {
            if self is UIWindow {
                return (self as! UIWindow).convert(rect, from: nil)
            } else {
                return convert(rect, from: nil)
            }
        }
    }
    // MARK: - Frame Shortcuts
    var left: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }
    var top: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }
    var right: CGFloat {
        get { frame.origin.x + frame.size.width }
        set { frame.origin.x = newValue - frame.size.width }
    }
    var bottom: CGFloat {
        get { frame.origin.y + frame.size.height }
        set { frame.origin.y = newValue - frame.size.height }
    }
    var width: CGFloat {
        get { frame.size.width }
        set { frame.size.width = newValue }
    }
    var height: CGFloat {
        get { frame.size.height }
        set { frame.size.height = newValue }
    }
    var centerX: CGFloat {
        get { center.x }
        set { center = CGPoint(x: newValue, y: center.y) }
    }
    var centerY: CGFloat {
        get { center.y }
        set { center = CGPoint(x: center.x, y: newValue) }
    }
    var origin: CGPoint {
        get { frame.origin }
        set { frame.origin = newValue }
    }
    var size: CGSize {
        get { frame.size }
        set { frame.size = newValue }
    }
} 