import UIKit
import ObjectiveC

// MARK: - BlockTarget
private class _ControlBlockTarget: NSObject {
    let block: (UIControl) -> Void
    init(_ block: @escaping (UIControl) -> Void) { self.block = block }
    @objc func invoke(_ sender: UIControl) { block(sender) }
}

private var controlTargetsKey: Void?
private var controlDebounceKey: Void?
private var controlHitTestEdgeKey: Void?

// MARK: - YYKit风格 UIControl 扩展
extension UIControl {
    /// Block方式添加事件
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, block: @escaping (UIControl) -> Void) {
        let target = _ControlBlockTarget(block)
        addTarget(target, action: #selector(_ControlBlockTarget.invoke(_:)), for: controlEvents)
        _storeTarget(target)
    }
    /// 移除所有Block事件
    func removeAllActions() {
        if let targets = objc_getAssociatedObject(self, &controlTargetsKey) as? NSMutableArray {
            for case let t as _ControlBlockTarget in targets {
                removeTarget(t, action: nil, for: .allEvents)
            }
            objc_setAssociatedObject(self, &controlTargetsKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // MARK: - 防抖点击
    /// 启用防抖，interval为防抖间隔（秒）
    func enableDebounce(interval: TimeInterval = 0.5) {
        objc_setAssociatedObject(self, &controlDebounceKey, interval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(_debounceAction), for: .touchUpInside)
    }
    /// 禁用防抖
    func disableDebounce() {
        objc_setAssociatedObject(self, &controlDebounceKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        removeTarget(self, action: #selector(_debounceAction), for: .touchUpInside)
    }
    @objc private func _debounceAction() {
        isEnabled = false
        let interval = (objc_getAssociatedObject(self, &controlDebounceKey) as? TimeInterval) ?? 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.isEnabled = true
        }
    }
    // MARK: - 扩大点击区域
    /// 设置点击区域扩展inset（正数为扩大，负数为缩小）
    func setHitTestEdgeInset(_ inset: UIEdgeInsets) {
        objc_setAssociatedObject(self, &controlHitTestEdgeKey, NSValue(uiEdgeInsets: inset), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    /// 获取点击区域扩展inset
    var hitTestEdgeInset: UIEdgeInsets? {
        (objc_getAssociatedObject(self, &controlHitTestEdgeKey) as? NSValue)?.uiEdgeInsetsValue
    }
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let inset = hitTestEdgeInset {
            let largerFrame = bounds.inset(by: inset.inverted)
            return largerFrame.contains(point)
        }
        return super.point(inside: point, with: event)
    }
    // MARK: - 事件穿透
    /// 是否允许事件穿透（true时点击事件会传递到下层view）
    var allowsEventPenetration: Bool {
        get { !isUserInteractionEnabled }
        set { isUserInteractionEnabled = !newValue }
    }
    // MARK: - 便捷状态设置
    func set(enabled: Bool) { isEnabled = enabled }
    func set(selected: Bool) { isSelected = selected }
    func set(highlighted: Bool) { isHighlighted = highlighted }
    // MARK: - 私有存储
    private func _storeTarget(_ target: _ControlBlockTarget) {
        var targets = objc_getAssociatedObject(self, &controlTargetsKey) as? NSMutableArray
        if targets == nil {
            targets = NSMutableArray()
            objc_setAssociatedObject(self, &controlTargetsKey, targets!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        targets!.add(target)
    }
}

// MARK: - UIEdgeInsets 反转
private extension UIEdgeInsets {
    var inverted: UIEdgeInsets {
        UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
} 