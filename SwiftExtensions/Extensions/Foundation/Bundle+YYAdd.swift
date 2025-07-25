import Foundation
import UIKit

// MARK: - YYKit风格 Bundle 扩展
extension Bundle {
    /// 获取当前屏幕适配的资源scale优先级数组（如[2,3,1]）
    static var preferredScales: [Int] {
        let scale = Int(UIScreen.main.scale)
        if scale <= 1 { return [1,2,3] }
        if scale == 2 { return [2,3,1] }
        return [3,2,1]
    }
    /// 查找适配scale的资源路径（类方法）
    static func pathForScaledResource(_ name: String, ofType ext: String?, inDirectory bundlePath: String) -> String? {
        guard !name.isEmpty else { return nil }
        if name.hasSuffix("/") {
            return Bundle.path(forResource: name, ofType: ext, inDirectory: bundlePath)
        }
        for scale in preferredScales {
            let scaledName: String
            if let ext = ext, !ext.isEmpty {
                scaledName = name.appendingNameScale(CGFloat(scale))
            } else {
                scaledName = name.appendingPathScale(CGFloat(scale))
            }
            if let path = Bundle.path(forResource: scaledName, ofType: ext, inDirectory: bundlePath) {
                return path
            }
        }
        return nil
    }
    /// 查找适配scale的资源路径（实例方法）
    func pathForScaledResource(_ name: String, ofType ext: String?) -> String? {
        guard !name.isEmpty else { return nil }
        if name.hasSuffix("/") {
            return path(forResource: name, ofType: ext)
        }
        for scale in Bundle.preferredScales {
            let scaledName: String
            if let ext = ext, !ext.isEmpty {
                scaledName = name.appendingNameScale(CGFloat(scale))
            } else {
                scaledName = name.appendingPathScale(CGFloat(scale))
            }
            if let path = path(forResource: scaledName, ofType: ext) {
                return path
            }
        }
        return nil
    }
    /// 查找适配scale的资源路径（实例方法，指定子目录）
    func pathForScaledResource(_ name: String, ofType ext: String?, inDirectory subpath: String?) -> String? {
        guard !name.isEmpty else { return nil }
        if name.hasSuffix("/") {
            return path(forResource: name, ofType: ext)
        }
        for scale in Bundle.preferredScales {
            let scaledName: String
            if let ext = ext, !ext.isEmpty {
                scaledName = name.appendingNameScale(CGFloat(scale))
            } else {
                scaledName = name.appendingPathScale(CGFloat(scale))
            }
            if let path = path(forResource: scaledName, ofType: ext, inDirectory: subpath) {
                return path
            }
        }
        return nil
    }
}

// MARK: - 资源名scale拼接扩展（与YYKit NSString+YYAdd一致）
extension String {
    /// 拼接@2x等scale后缀到文件名（不带扩展名）
    func appendingNameScale(_ scale: CGFloat) -> String {
        guard scale > 1 else { return self }
        let ext = (self as NSString).pathExtension
        let name = (self as NSString).deletingPathExtension
        return ext.isEmpty ? "\(name)@\(Int(scale))x" : "\(name)@\(Int(scale))x.\(ext)"
    }
    /// 拼接@2x等scale后缀到完整路径（带扩展名）
    func appendingPathScale(_ scale: CGFloat) -> String {
        guard scale > 1 else { return self }
        let ext = (self as NSString).pathExtension
        let name = (self as NSString).deletingPathExtension
        return ext.isEmpty ? "\(name)@\(Int(scale))x" : "\(name)@\(Int(scale))x.\(ext)"
    }
} 