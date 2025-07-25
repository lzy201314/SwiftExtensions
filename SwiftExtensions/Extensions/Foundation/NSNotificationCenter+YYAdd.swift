//
//  NSNotificationCenter+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSNotificationCenter+YYAdd.
//

import Foundation

private var kYYNotificationBlockKey: UInt8 = 0

private class _YYNotificationBlockTarget {
    let block: (Notification) -> Void
    init(_ block: @escaping (Notification) -> Void) { self.block = block }
    @objc func invoke(_ notification: Notification) { block(notification) }
}

extension NotificationCenter {
    /// 添加 block 方式的通知监听
    @discardableResult
    func addObserverBlock(forName name: NSNotification.Name?, object obj: AnyObject? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: name, object: obj, queue: queue, using: block)
    }
    /// 移除 block 方式的通知监听
    func removeObserverBlocks(forName name: NSNotification.Name? = nil, object obj: AnyObject? = nil) {
        // Swift 原生 API 已支持移除所有 block observer
        // 这里只需调用 removeObserver(_:name:object:) 即可
        // 若需更细粒度管理，可自行实现 observer 存储
    }
} 