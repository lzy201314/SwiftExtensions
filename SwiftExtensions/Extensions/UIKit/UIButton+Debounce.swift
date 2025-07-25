import UIKit

private var debounceKey: Void?
private var enableDebounceKey: Void?
private var debounceIntervalKey: Void?

extension UIButton {
    /// 是否启用防抖，默认 true。外部可设置为 false 关闭防抖功能。
    /// 用法：button.enableDebounce = false // 关闭防抖
    var enableDebounce: Bool {
        get {
            (objc_getAssociatedObject(self, &enableDebounceKey) as? Bool) ?? true
        }
        set {
            objc_setAssociatedObject(self, &enableDebounceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 防抖间隔，默认 1.0 秒。外部可设置不同按钮不同防抖时间。
    /// 用法：button.debounceInterval = 1.5
    var debounceInterval: TimeInterval {
        get {
            (objc_getAssociatedObject(self, &debounceIntervalKey) as? TimeInterval) ?? 1.0
        }
        set {
            objc_setAssociatedObject(self, &debounceIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 内部防抖标记，防止短时间重复点击
    private var isDebouncing: Bool {
        get { (objc_getAssociatedObject(self, &debounceKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &debounceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// 按钮防抖点击扩展。debounceInterval 秒内只响应一次点击，期间按钮自动禁用，防止重复触发。
    /// - Parameters:
    ///   - interval: 防抖间隔，默认取 debounceInterval 属性
    ///   - action: 点击回调，只有未被防抖时才会执行
    /// - 注意：
    ///   1. 若 enableDebounce = false，则每次点击都会立即执行 action。
    ///   2. 若 interval 内多次点击，仅第一次会响应，按钮自动禁用，interval 后恢复可用。
    ///   3. 推荐用于网络请求、表单提交等防止重复点击场景。
    func debounce(interval: TimeInterval? = nil, action: @escaping () -> Void) {
        guard enableDebounce else {
            action()
            return
        }
        guard !isDebouncing else { return }
        isDebouncing = true
        action()
        let useInterval = interval ?? debounceInterval
        self.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + useInterval) { [weak self] in
            self?.isDebouncing = false
            self?.isEnabled = true
        }
    }
} 