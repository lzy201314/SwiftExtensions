import UIKit

// MARK: - 关联对象键
private var buttonActionKey: Void?
private var buttonLongPressKey: Void?
private var buttonHapticKey: Void?
private var buttonDebounceKey: Void?
private var buttonStateActionsKey: Void?

extension UIButton {
    
    // MARK: - 基础点击事件
    
    /// 给UIButton添加闭包点击事件
    /// - Parameter action: 点击回调
    func onTap(_ action: @escaping () -> Void) {
        objc_setAssociatedObject(self, &buttonActionKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
    }
    
    /// 移除点击事件
    func removeTapAction() {
        removeTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
        objc_setAssociatedObject(self, &buttonActionKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    // MARK: - 长按事件
    
    /// 添加长按事件
    /// - Parameters:
    ///   - minimumPressDuration: 最小长按时间，默认0.5秒
    ///   - action: 长按回调
    func onLongPress(minimumPressDuration: TimeInterval = 0.5, action: @escaping () -> Void) {
        objc_setAssociatedObject(self, &buttonLongPressKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = minimumPressDuration
        addGestureRecognizer(longPress)
    }
    
    /// 移除长按事件
    func removeLongPressAction() {
        gestureRecognizers?.forEach { gesture in
            if gesture is UILongPressGestureRecognizer {
                removeGestureRecognizer(gesture)
            }
        }
        objc_setAssociatedObject(self, &buttonLongPressKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    // MARK: - 震动反馈
    
    /// 启用点击震动反馈
    /// - Parameter style: 震动样式，默认 .light
    func enableHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let haptic = UIImpactFeedbackGenerator(style: style)
        objc_setAssociatedObject(self, &buttonHapticKey, haptic, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        haptic.prepare()
    }
    
    /// 禁用震动反馈
    func disableHapticFeedback() {
        objc_setAssociatedObject(self, &buttonHapticKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // MARK: - 防抖功能
    
    // 已在 UIControl+YYAdd.swift 实现防抖相关方法，这里不再重复实现 enableDebounce/disableDebounce
    
    // MARK: - 状态变化事件
    
    /// 设置不同状态下的点击事件
    /// - Parameters:
    ///   - normal: 正常状态点击事件
    ///   - highlighted: 高亮状态点击事件
    ///   - disabled: 禁用状态点击事件
    func setStateActions(normal: (() -> Void)? = nil, 
                        highlighted: (() -> Void)? = nil, 
                        disabled: (() -> Void)? = nil) {
        let actions = ["normal": normal, "highlighted": highlighted, "disabled": disabled]
        objc_setAssociatedObject(self, &buttonStateActionsKey, actions, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    // MARK: - 组合功能
    
    /// 一键设置完整的按钮交互（点击+防抖+震动）
    /// - Parameters:
    ///   - action: 点击回调
    ///   - debounceInterval: 防抖间隔，默认0.5秒
    ///   - hapticStyle: 震动样式，默认 .light
    func setupCompleteInteraction(action: @escaping () -> Void, 
                                 debounceInterval: TimeInterval = 0.5,
                                 hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        // 启用防抖
        // 已在 UIControl+YYAdd.swift 实现防抖相关方法，这里不再重复实现 enableDebounce/disableDebounce
        // 启用震动
        enableHapticFeedback(style: hapticStyle)
        // 设置点击事件
        onTap { [weak self] in
            self?.triggerActionWithDebounceAndHaptic(action: action)
        }
    }
    
    // MARK: - 动画效果
    
    /// 添加点击缩放动画
    /// - Parameters:
    ///   - scale: 缩放比例，默认0.95
    ///   - duration: 动画时长，默认0.1秒
    func addScaleAnimation(scale: CGFloat = 0.95, duration: TimeInterval = 0.1) {
        onTap { [weak self] in
            UIView.animate(withDuration: duration, animations: {
                self?.transform = CGAffineTransform(scaleX: scale, y: scale)
            }) { _ in
                UIView.animate(withDuration: duration) {
                    self?.transform = .identity
                }
            }
        }
    }
    
    /// 添加点击波纹效果
    /// - Parameters:
    ///   - color: 波纹颜色，默认白色半透明
    ///   - duration: 动画时长，默认0.3秒
    func addRippleEffect(color: UIColor = UIColor.white.withAlphaComponent(0.3), duration: TimeInterval = 0.3) {
        onTap { [weak self] in
            guard let self = self else { return }
            
            let ripple = UIView()
            ripple.backgroundColor = color
            ripple.layer.cornerRadius = 2
            ripple.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
            ripple.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            self.addSubview(ripple)
            
            UIView.animate(withDuration: duration, animations: {
                ripple.transform = CGAffineTransform(scaleX: 50, y: 50)
                ripple.alpha = 0
            }) { _ in
                ripple.removeFromSuperview()
            }
        }
    }
    
    // MARK: - 私有方法
    
    @objc private func handleButtonAction() {
        // 检查防抖
        if let debounceInfo = objc_getAssociatedObject(self, &buttonDebounceKey) as? [String: Any],
           let isDebouncing = debounceInfo["isDebouncing"] as? Bool,
           isDebouncing {
            return
        }
        
        // 触发震动
        if let haptic = objc_getAssociatedObject(self, &buttonHapticKey) as? UIImpactFeedbackGenerator {
            haptic.impactOccurred()
        }
        
        // 执行点击回调
        if let action = objc_getAssociatedObject(self, &buttonActionKey) as? () -> Void {
            action()
        }
        
        // 设置防抖状态
        if var debounceInfo = objc_getAssociatedObject(self, &buttonDebounceKey) as? [String: Any],
           let interval = debounceInfo["interval"] as? TimeInterval {
            debounceInfo["isDebouncing"] = true
            objc_setAssociatedObject(self, &buttonDebounceKey, debounceInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
                if var updatedInfo = objc_getAssociatedObject(self, &buttonDebounceKey) as? [String: Any] {
                    updatedInfo["isDebouncing"] = false
                    objc_setAssociatedObject(self, &buttonDebounceKey, updatedInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let action = objc_getAssociatedObject(self, &buttonLongPressKey) as? () -> Void {
                action()
            }
        }
    }
    
    private func triggerActionWithDebounceAndHaptic(action: @escaping () -> Void) {
        // 检查防抖
        if let debounceInfo = objc_getAssociatedObject(self, &buttonDebounceKey) as? [String: Any],
           let isDebouncing = debounceInfo["isDebouncing"] as? Bool,
           isDebouncing {
            return
        }
        
        // 触发震动
        if let haptic = objc_getAssociatedObject(self, &buttonHapticKey) as? UIImpactFeedbackGenerator {
            haptic.impactOccurred()
        }
        
        // 执行回调
        action()
        
        // 设置防抖状态
        if var debounceInfo = objc_getAssociatedObject(self, &buttonDebounceKey) as? [String: Any],
           let interval = debounceInfo["interval"] as? TimeInterval {
            debounceInfo["isDebouncing"] = true
            objc_setAssociatedObject(self, &buttonDebounceKey, debounceInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
                if var updatedInfo = objc_getAssociatedObject(self, &buttonDebounceKey) as? [String: Any] {
                    updatedInfo["isDebouncing"] = false
                    objc_setAssociatedObject(self, &buttonDebounceKey, updatedInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }
    }
}

// MARK: - 便捷扩展

extension UIButton {
    
    /// 快速设置带防抖的点击事件
    /// - Parameters:
    ///   - interval: 防抖间隔
    ///   - action: 点击回调
    func onTapDebounced(interval: TimeInterval = 0.5, action: @escaping () -> Void) {
        setupCompleteInteraction(action: action, debounceInterval: interval)
    }
    
    /// 快速设置带震动的点击事件
    /// - Parameters:
    ///   - hapticStyle: 震动样式
    ///   - action: 点击回调
    func onTapWithHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .light, action: @escaping () -> Void) {
        setupCompleteInteraction(action: action, hapticStyle: style)
    }
    
    /// 快速设置带动画的点击事件
    /// - Parameters:
    ///   - animationType: 动画类型
    ///   - action: 点击回调
    func onTapWithAnimation(_ animationType: ButtonAnimationType = .scale, action: @escaping () -> Void) {
        switch animationType {
        case .scale:
            addScaleAnimation()
        case .ripple:
            addRippleEffect()
        }
        onTap(action)
    }
}

// MARK: - 动画类型枚举

enum ButtonAnimationType {
    case scale
    case ripple
}

// MARK: - 使用示例

/*
 基础用法：
 
 // 简单点击事件
 button.onTap { [weak self] in
     self?.handleTap()
 }
 
 // 长按事件
 button.onLongPress(minimumPressDuration: 1.0) { [weak self] in
     self?.showDeleteConfirmation()
 }
 
 // 震动反馈
 button.enableHapticFeedback(style: .medium)
 
 // 防抖点击
 button.onTapDebounced(interval: 0.5) { [weak self] in
     self?.handleNetworkRequest()
 }
 
 // 带动画的点击
 button.onTapWithAnimation(.scale) { [weak self] in
     self?.handleTap()
 }
 
 // 一键设置完整交互（防抖+震动）
 button.setupCompleteInteraction(
     action: { [weak self] in
         self?.submitForm()
     },
     debounceInterval: 0.5,
     hapticStyle: .light
 )
 
 动画效果：
 
 // 缩放动画
 button.addScaleAnimation(scale: 0.9, duration: 0.15)
 
 // 波纹效果
 button.addRippleEffect(
     color: UIColor.blue.withAlphaComponent(0.3),
     duration: 0.4
 )
 
 实际应用场景：
 
 // 1. 提交按钮（防抖+震动）
 submitButton.setupCompleteInteraction(
     action: { [weak self] in self?.submitOrder() },
     debounceInterval: 1.0,
     hapticStyle: .medium
 )
 
 // 2. 删除按钮（长按确认）
 deleteButton.onLongPress(minimumPressDuration: 1.5) { [weak self] in
     self?.showDeleteAlert()
 }
 
 // 3. 游戏按钮（动画+震动）
 gameButton.onTapWithAnimation(.ripple)
 gameButton.enableHapticFeedback(style: .heavy)
 gameButton.onTap { [weak self] in self?.playGame() }
 
 // 4. 刷新按钮（防抖）
 refreshButton.onTapDebounced(interval: 2.0) { [weak self] in
     self?.refreshData()
 }
 */ 