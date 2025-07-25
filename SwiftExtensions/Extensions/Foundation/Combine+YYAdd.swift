//
//  Combine+YYAdd.swift
//  tongshengbao_cn
//
//  Created by AI for Combine convenience extensions.
//

import Foundation
import Combine

public extension Publisher {
    /// 便捷 assign（弱引用目标，防止循环引用）
    func assignWeak<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> AnyCancellable where Failure == Never {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    /// 便捷 sink（弱引用目标，防止循环引用）
    func sinkWeak(receiveValue: @escaping (Output) -> Void) -> AnyCancellable where Failure == Never {
        sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }
    /// 只关心完成，不关心值
    func asVoid() -> AnyPublisher<Void, Failure> {
        map { _ in () }.eraseToAnyPublisher()
    }
    /// 忽略错误，转为 Never
    func ignoreError() -> AnyPublisher<Output, Never> {
        self.catch { _ in Empty<Output, Never>() }.eraseToAnyPublisher()
    }
    /// 主线程延迟
    func delayMain(for interval: TimeInterval) -> AnyPublisher<Output, Failure> {
        delay(for: .seconds(interval), scheduler: DispatchQueue.main).eraseToAnyPublisher()
    }
    /// 主线程节流
    func throttleMain(for interval: TimeInterval, latest: Bool = true) -> AnyPublisher<Output, Failure> {
        throttle(for: .seconds(interval), scheduler: DispatchQueue.main, latest: latest).eraseToAnyPublisher()
    }
    /// withLatestFrom
    func withLatestFrom<Other: Publisher>(_ other: Other) -> AnyPublisher<(Output, Other.Output), Failure> where Other.Failure == Failure {
        self.combineLatest(other).eraseToAnyPublisher()
    }
} 