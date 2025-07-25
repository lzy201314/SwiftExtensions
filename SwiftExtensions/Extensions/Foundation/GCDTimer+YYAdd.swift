//
//  GCDTimer+YYAdd.swift
//  tongshengbao_cn
//
//  Created by AI migration for GCD timer utility.
//

import Foundation

public class GCDTimer {
    private var timer: DispatchSourceTimer?
    private var isRunning = false
    
    /// 创建并启动一个 GCD 定时器
    /// - Parameters:
    ///   - interval: 时间间隔（秒）
    ///   - repeats: 是否重复
    ///   - queue: 定时器回调队列，默认主队列
    ///   - block: 回调 block
    public init(interval: TimeInterval, repeats: Bool = true, queue: DispatchQueue = .main, block: @escaping () -> Void) {
        timer = DispatchSource.makeTimerSource(queue: queue)
        if repeats {
            timer?.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            timer?.schedule(deadline: .now() + interval, repeating: .infinity)
        }
        timer?.setEventHandler { [weak self] in
            if !repeats {
                self?.cancel()
            }
            block()
        }
        timer?.resume()
        isRunning = true
    }
    /// 取消定时器
    public func cancel() {
        guard isRunning else { return }
        timer?.cancel()
        timer = nil
        isRunning = false
    }
    deinit {
        cancel()
    }
}

public extension GCDTimer {
    /// 快捷静态方法
    @discardableResult
    static func scheduledTimer(interval: TimeInterval, repeats: Bool = true, queue: DispatchQueue = .main, block: @escaping () -> Void) -> GCDTimer {
        return GCDTimer(interval: interval, repeats: repeats, queue: queue, block: block)
    }
} 