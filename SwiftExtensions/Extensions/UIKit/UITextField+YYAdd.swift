//
//  UITextField+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UITextField+YYAdd.
//

import UIKit

extension UITextField {
    /// 选中全部文本
    func selectAllText() {
        if let range = textRange(from: beginningOfDocument, to: endOfDocument) {
            selectedTextRange = range
        }
    }
    /// 选中指定范围文本
    func setSelectedRange(_ range: NSRange) {
        guard let start = position(from: beginningOfDocument, offset: range.location),
              let end = position(from: beginningOfDocument, offset: range.location + range.length),
              let textRange = textRange(from: start, to: end) else { return }
        selectedTextRange = textRange
    }
} 