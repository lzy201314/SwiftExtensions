//
//  DispatchQueue+YYAdd.swift
//  tongshengbao_cn
//
//  Created by AI on 2024/06/09. GCD 多线程扩展，便于日常并发开发。
//

import Foundation

public extension DispatchQueue {
    /// 主线程异步执行
    static func asyncOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async { block() }
        }
    }
    /// 主线程同步执行
    static func syncOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync { block() }
        }
    }
    /// 全局队列异步执行
    static func asyncOnGlobal(qos: DispatchQoS.QoSClass = .default, _ block: @escaping () -> Void) {
        DispatchQueue.global(qos: qos).async { block() }
    }
    /// 全局队列同步执行
    static func syncOnGlobal(qos: DispatchQoS.QoSClass = .default, _ block: @escaping () -> Void) {
        DispatchQueue.global(qos: qos).sync { block() }
    }
    /// 延迟执行
    static func asyncAfter(_ delay: TimeInterval, on queue: DispatchQueue = .main, _ block: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + delay, execute: block)
    }
    /// 只执行一次（线程安全）
    private static var _onceTracker = [String]()
    static func once(token: String, _ block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) { return }
        _onceTracker.append(token)
        block()
    }
    /// 并发组：批量异步任务，全部完成后回调
    static func groupAsync(tasks: [() -> Void], completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for task in tasks {
            DispatchQueue.global().async(group: group) { task() }
        }
        group.notify(queue: .main) { completion() }
    }
    /// 信号量：控制最大并发数
    static func concurrentLimit(tasks: [() -> Void], maxConcurrent: Int, completion: @escaping () -> Void) {
        let semaphore = DispatchSemaphore(value: maxConcurrent)
        let group = DispatchGroup()
        for task in tasks {
            group.enter()
            DispatchQueue.global().async {
                semaphore.wait()
                task()
                semaphore.signal()
                group.leave()
            }
        }
        group.notify(queue: .main) { completion() }
    }
    /// barrier：并发队列中的栅栏任务
    func asyncBarrier(_ block: @escaping () -> Void) {
        self.async(flags: .barrier, execute: block)
    }
    /// GCD定时器（返回DispatchSourceTimer，需手动管理生命周期）
    static func scheduledTimer(interval: TimeInterval, repeats: Bool = true, queue: DispatchQueue = .main, handler: @escaping () -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: queue)
        let deadline = DispatchTime.now() + interval
        let repeating = repeats ? interval : .infinity
        timer.schedule(deadline: deadline, repeating: repeating)
        timer.setEventHandler(handler: handler)
        timer.resume()
        return timer
    }
} 