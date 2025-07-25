//
//  UIScrollView+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIScrollView+YYAdd.
//

import UIKit

extension UIScrollView {
    func scrollToTop(animated: Bool = true) {
        var off = contentOffset
        off.y = 0 - contentInset.top
        setContentOffset(off, animated: animated)
    }
    func scrollToBottom(animated: Bool = true) {
        var off = contentOffset
        off.y = contentSize.height - bounds.size.height + contentInset.bottom
        setContentOffset(off, animated: animated)
    }
    func scrollToLeft(animated: Bool = true) {
        var off = contentOffset
        off.x = 0 - contentInset.left
        setContentOffset(off, animated: animated)
    }
    func scrollToRight(animated: Bool = true) {
        var off = contentOffset
        off.x = contentSize.width - bounds.size.width + contentInset.right
        setContentOffset(off, animated: animated)
    }
    // 兼容OC风格命名
    func scrollToTopAnimated(_ animated: Bool) { scrollToTop(animated: animated) }
    func scrollToBottomAnimated(_ animated: Bool) { scrollToBottom(animated: animated) }
    func scrollToLeftAnimated(_ animated: Bool) { scrollToLeft(animated: animated) }
    func scrollToRightAnimated(_ animated: Bool) { scrollToRight(animated: animated) }
} 