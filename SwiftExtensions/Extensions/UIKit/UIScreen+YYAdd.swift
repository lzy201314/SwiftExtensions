//
//  UIScreen+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIScreen+YYAdd.
//

import UIKit

extension UIScreen {
    /// 主屏 scale
    static var screenScale: CGFloat {
        return UIScreen.main.scale
    }
    /// 当前屏幕方向下的 bounds
    var currentBounds: CGRect {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
            return self.bounds
        }
        return boundsForOrientation(orientation)
    }
    /// 指定方向下的 bounds
    func boundsForOrientation(_ orientation: UIInterfaceOrientation) -> CGRect {
        var bounds = self.bounds
        if orientation.isLandscape {
            let w = bounds.size.width
            bounds.size.width = bounds.size.height
            bounds.size.height = w
        }
        return bounds
    }
    /// 屏幕像素尺寸（宽小于高）
    var sizeInPixel: CGSize {
        if self == UIScreen.main {
            // 仅主屏特殊机型处理，其他直接用 nativeBounds/scale
            // 可根据需要补充机型判断
        }
        if responds(to: #selector(getter: UIScreen.nativeBounds)) {
            var size = self.nativeBounds.size
            if size.height < size.width {
                swap(&size.width, &size.height)
            }
            return size
        } else {
            var size = self.bounds.size
            size.width *= self.scale
            size.height *= self.scale
            if size.height < size.width {
                swap(&size.width, &size.height)
            }
            return size
        }
    }
    /// 屏幕 PPI（仅主屏，部分机型有特殊值，否则返回 326）
    var pixelsPerInch: CGFloat {
        if self != UIScreen.main { return 326 }
        // 仅主屏，部分机型特殊处理
        let model = UIDevice.current.modelIdentifier
        let ppiMap: [String: CGFloat] = [
            "iPhone7,1": 401, "iPhone8,2": 401, "iPhone9,2": 401, "iPhone9,4": 401,
            "iPad6,7": 264, "iPad6,8": 264
        ]
        if let ppi = ppiMap[model] { return ppi }
        return 326
    }
}

// MARK: - UIDevice 机型标识
import Foundation
import UIKit

extension UIDevice {
    /// 机型标识，如 iPhone10,1
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
} 