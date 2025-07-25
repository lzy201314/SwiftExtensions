//
//  NSNumber+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSNumber+YYAdd.
//

import Foundation

extension NSNumber {
    /// 根据字符串内容智能生成 NSNumber，支持十进制、十六进制、布尔、nil/null等
    /// - Parameter string: 字符串
    /// - Returns: NSNumber 或 nil
    public static func number(with string: String) -> NSNumber? {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if str.isEmpty { return nil }
        let boolMap: [String: NSNumber?] = [
            "true": true as NSNumber,
            "yes": true as NSNumber,
            "false": false as NSNumber,
            "no": false as NSNumber,
            "nil": nil,
            "null": nil,
            "<null>": nil
        ]
        if let mapped = boolMap[str] { return mapped }
        // hex
        var sign = 0
        if str.hasPrefix("0x") { sign = 1 }
        else if str.hasPrefix("-0x") { sign = -1 }
        if sign != 0 {
            let hexStr = str.replacingOccurrences(of: "-", with: "")
            if let num = UInt64(hexStr.dropFirst(2), radix: 16) {
                return NSNumber(value: Int64(num) * Int64(sign))
            } else {
                return nil
            }
        }
        // decimal
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)
    }
} 