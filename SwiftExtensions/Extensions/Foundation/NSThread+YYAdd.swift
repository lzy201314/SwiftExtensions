//
//  NSThread+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSThread+YYAdd.
//

import Foundation
import CoreFoundation

extension Thread {
    /// 为当前线程的 RunLoop 添加自动释放池，适用于自定义线程的 RunLoop 管理。
    /// 主线程无需调用，已自动管理。
    public class func addAutoreleasePoolToCurrentRunloop() {
        if Thread.isMainThread { return } // 主线程已自动管理
        let thread = Thread.current
        let poolKey = "YYNSThreadAutoleasePoolKey"
        if thread.threadDictionary[poolKey] != nil { return } // 已添加
        RunLoop.current.addAutoreleasePoolObserverIfNeeded(poolKey: poolKey)
        thread.threadDictionary[poolKey] = poolKey // 标记已添加
    }
}

private extension RunLoop {
    func addAutoreleasePoolObserverIfNeeded(poolKey: String) {
        // 仅添加一次
        let observerKey = "YYRunLoopAutoreleasePoolObserverKey"
        if CFRunLoopGetCurrent().getAssociatedObject(forKey: observerKey) != nil { return }
        // 监听 RunLoop 生命周期，管理自动释放池
        // 0x1 = entry, 0x20 = beforeWaiting, 0x40 = exit
        let activities: CFOptionFlags = 0x1 | 0x20 | 0x40
        guard let observer = CFRunLoopObserverCreateWithHandler(nil, activities, true, 0, { (_, activity) in
            if activity.rawValue & CFRunLoopActivity.entry.rawValue != 0 {
                _YYAutoreleasePoolStack.push()
            }
            if activity.rawValue & CFRunLoopActivity.beforeWaiting.rawValue != 0 {
                _YYAutoreleasePoolStack.pop()
                _YYAutoreleasePoolStack.push()
            }
            if activity.rawValue & CFRunLoopActivity.exit.rawValue != 0 {
                _YYAutoreleasePoolStack.pop()
            }
        }) else { return }
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .commonModes)
        CFRunLoopGetCurrent().setAssociatedObject(observer, forKey: observerKey)
    }
}

// MARK: - AutoreleasePool Stack
private class _YYAutoreleasePoolStack {
    private static var poolStackKey = "YYNSThreadAutoleasePoolStackKey"
    static func push() {
        let thread = Thread.current
        let dic = thread.threadDictionary
        var poolStack = dic[poolStackKey] as? NSMutableArray
        if poolStack == nil {
            poolStack = NSMutableArray()
            dic[poolStackKey] = poolStack
        }
        let pool = _YYAutoreleasePool()
        poolStack?.add(pool)
    }
    static func pop() {
        let thread = Thread.current
        let dic = thread.threadDictionary
        guard let poolStack = dic[poolStackKey] as? NSMutableArray, poolStack.count > 0 else { return }
        poolStack.removeLastObject()
    }
}

private class _YYAutoreleasePool {}

// MARK: - CFRunLoop Associated Object
private var runLoopAssociatedObjects = NSMapTable<AnyObject, NSMutableDictionary>(keyOptions: .weakMemory, valueOptions: .strongMemory)
private extension CFRunLoop {
    func getAssociatedObject(forKey key: String) -> AnyObject? {
        let dict = runLoopAssociatedObjects.object(forKey: self) ?? NSMutableDictionary()
        return dict[key as NSString] as AnyObject?
    }
    func setAssociatedObject(_ object: AnyObject, forKey key: String) {
        let dict = runLoopAssociatedObjects.object(forKey: self) ?? NSMutableDictionary()
        dict[key as NSString] = object
        runLoopAssociatedObjects.setObject(dict, forKey: self)
    }
} 
