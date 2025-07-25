//
//  UIBarButtonItem+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIBarButtonItem+YYAdd.
//

import UIKit
import ObjectiveC

private var kBarButtonItemActionBlockKey: UInt8 = 0

private class _YYUIBarButtonItemBlockTarget: NSObject {
    let block: (UIBarButtonItem) -> Void
    init(_ block: @escaping (UIBarButtonItem) -> Void) {
        self.block = block
    }
    @objc func invoke(_ sender: UIBarButtonItem) {
        block(sender)
    }
}

extension UIBarButtonItem {
    /// 支持 block 方式点击事件
    var actionBlock: ((UIBarButtonItem) -> Void)? {
        get {
            if let target = objc_getAssociatedObject(self, &kBarButtonItemActionBlockKey) as? _YYUIBarButtonItemBlockTarget {
                return target.block
            }
            return nil
        }
        set {
            if let newValue = newValue {
                let target = _YYUIBarButtonItemBlockTarget(newValue)
                objc_setAssociatedObject(self, &kBarButtonItemActionBlockKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.target = target
                self.action = #selector(_YYUIBarButtonItemBlockTarget.invoke(_:))
            } else {
                objc_setAssociatedObject(self, &kBarButtonItemActionBlockKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.target = nil
                self.action = nil
            }
        }
    }
} 