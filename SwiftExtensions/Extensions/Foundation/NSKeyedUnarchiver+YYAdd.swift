//
//  NSKeyedUnarchiver+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSKeyedUnarchiver+YYAdd.
//

import Foundation

extension NSKeyedUnarchiver {
    /// 兼容 iOS 12 及以下的 unarchiveObject(with:) 方法，iOS 13+ 推荐用 unarchiveTopLevelObjectWithData
    static func unarchiveObjectCompat(with data: Data) -> Any? {
        if #available(iOS 11.0, *) {
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
    }
} 