//
//  NSObject+YYAddForKVO.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSObject+YYAddForKVO.
//

import Foundation
import ObjectiveC

private var kKVOBlockKey: UInt8 = 0

private class _YYNSObjectKVOBlockTarget: NSObject {
    let block: (_ obj: AnyObject, _ oldVal: Any?, _ newVal: Any?) -> Void
    init(_ block: @escaping (_ obj: AnyObject, _ oldVal: Any?, _ newVal: Any?) -> Void) {
        self.block = block
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let block = self.block
        guard let object = object as AnyObject?, let change = change else { return }
        if let isPrior = change[.notificationIsPriorKey] as? Bool, isPrior { return }
        guard let kind = change[.kindKey] as? UInt, kind == NSKeyValueChange.setting.rawValue else { return }
        let oldVal = (change[.oldKey] is NSNull) ? nil : change[.oldKey]
        let newVal = (change[.newKey] is NSNull) ? nil : change[.newKey]
        block(object, oldVal, newVal)
    }
}

extension NSObject {
    func addObserverBlock(forKeyPath keyPath: String, block: @escaping (_ obj: AnyObject, _ oldVal: Any?, _ newVal: Any?) -> Void) {
        let target = _YYNSObjectKVOBlockTarget(block)
        var allBlocks = _yy_allNSObjectObserverBlocks()
        var arr = allBlocks[keyPath] ?? []
        arr.append(target)
        allBlocks[keyPath] = arr
        _yy_setAllNSObjectObserverBlocks(allBlocks)
        self.addObserver(target, forKeyPath: keyPath, options: [.new, .old], context: nil)
    }
    func removeObserverBlocks(forKeyPath keyPath: String) {
        var allBlocks = _yy_allNSObjectObserverBlocks()
        guard let arr = allBlocks[keyPath] else { return }
        for target in arr {
            self.removeObserver(target, forKeyPath: keyPath)
        }
        allBlocks.removeValue(forKey: keyPath)
        _yy_setAllNSObjectObserverBlocks(allBlocks)
    }
    func removeObserverBlocks() {
        var allBlocks = _yy_allNSObjectObserverBlocks()
        for (key, arr) in allBlocks {
            for target in arr {
                self.removeObserver(target, forKeyPath: key)
            }
        }
        allBlocks.removeAll()
        _yy_setAllNSObjectObserverBlocks(allBlocks)
    }
    // MARK: - Private
    private func _yy_allNSObjectObserverBlocks() -> [String: [_YYNSObjectKVOBlockTarget]] {
        objc_getAssociatedObject(self, &kKVOBlockKey) as? [String: [_YYNSObjectKVOBlockTarget]] ?? [:]
    }
    private func _yy_setAllNSObjectObserverBlocks(_ dict: [String: [_YYNSObjectKVOBlockTarget]]) {
        objc_setAssociatedObject(self, &kKVOBlockKey, dict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
} 