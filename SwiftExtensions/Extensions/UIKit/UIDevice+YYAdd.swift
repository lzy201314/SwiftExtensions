//
//  UIDevice+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIDevice+YYAdd.
//

import UIKit

extension UIDevice {
    /// 设备机型标识，如 iPhone10,1
    var yy_modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    /// 是否模拟器
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    /// 是否越狱（简单判断）
    var isJailbroken: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        let paths = ["/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd", "/etc/apt"]
        for path in paths { if FileManager.default.fileExists(atPath: path) { return true } }
        if canOpen(path: "/private/var/lib/apt/") { return true }
        return false
        #endif
    }
    private func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        if file != nil { fclose(file); return true }
        return false
    }
    /// 系统主版本号
    var systemMajorVersion: Int {
        return Int(UIDevice.current.systemVersion.split(separator: ".").first ?? "0") ?? 0
    }
} 