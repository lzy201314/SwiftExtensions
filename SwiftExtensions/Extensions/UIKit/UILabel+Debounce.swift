import UIKit

private var labelDebounceKey: Void?
private var labelDebounceIntervalKey: Void?

extension UILabel {
    /// 防抖间隔，默认0.5秒
    var debounceInterval: TimeInterval {
        get { (objc_getAssociatedObject(self, &labelDebounceIntervalKey) as? TimeInterval) ?? 0.5 }
        set { objc_setAssociatedObject(self, &labelDebounceIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// 内部防抖标记
    private var isDebouncing: Bool {
        get { (objc_getAssociatedObject(self, &labelDebounceKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &labelDebounceKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    /// 给UILabel添加防抖点击事件
    /// - Parameters:
    ///   - interval: 防抖间隔，默认0.5秒
    ///   - action: 点击回调
    func debounceTap(interval: TimeInterval = 0.5, action: @escaping () -> Void) {
        isUserInteractionEnabled = true
        debounceInterval = interval
        let tap = UITapGestureRecognizer()
        tap.addTargetClosure { [weak self] in
            guard let self = self else { return }
            guard !self.isDebouncing else { return }
            self.isDebouncing = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + self.debounceInterval) { [weak self] in
                self?.isDebouncing = false
            }
        }
        addGestureRecognizer(tap)
    }
}

// MARK: - UITapGestureRecognizer闭包支持
private var tapActionKey: Void?
extension UITapGestureRecognizer {
    func addTargetClosure(_ closure: @escaping () -> Void) {
        objc_setAssociatedObject(self, &tapActionKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(handleAction))
    }
    @objc private func handleAction() {
        if let closure = objc_getAssociatedObject(self, &tapActionKey) as? () -> Void {
            closure()
        }
    }
} 