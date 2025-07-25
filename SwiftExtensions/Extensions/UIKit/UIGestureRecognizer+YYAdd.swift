//
//  UIGestureRecognizer+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIGestureRecognizer+YYAdd.
//

import UIKit
import ObjectiveC

private var kGestureBlockKey: UInt8 = 0

private class _YYGestureBlockTarget: NSObject {
    let block: (UIGestureRecognizer) -> Void
    init(_ block: @escaping (UIGestureRecognizer) -> Void) { self.block = block }
    @objc func invoke(_ gesture: UIGestureRecognizer) { block(gesture) }
}

extension UIGestureRecognizer {
    /// 添加 block 方式回调
    func addActionBlock(_ block: @escaping (UIGestureRecognizer) -> Void) {
        let target = _YYGestureBlockTarget(block)
        addTarget(target, action: #selector(_YYGestureBlockTarget.invoke(_:)))
        var targets = objc_getAssociatedObject(self, &kGestureBlockKey) as? NSMutableArray ?? NSMutableArray()
        targets.add(target)
        objc_setAssociatedObject(self, &kGestureBlockKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    /// 移除所有 block 回调
    func removeAllActionBlocks() {
        if let targets = objc_getAssociatedObject(self, &kGestureBlockKey) as? NSMutableArray {
            for case let target as _YYGestureBlockTarget in targets {
                removeTarget(target, action: #selector(_YYGestureBlockTarget.invoke(_:)))
            }
            targets.removeAllObjects()
        }
    }
} 