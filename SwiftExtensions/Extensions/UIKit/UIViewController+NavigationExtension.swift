import UIKit

// MARK: - UIViewController 导航扩展

/**
 * UIViewController 导航扩展
 * 
 * 提供通用的导航方法，简化iOS应用中的导航逻辑处理
 * 
 * 主要功能：
 * - dismissToRootViewController(): 回到根视图控制器（常用于登录成功后回到主页）
 * - handleLoginSuccess(): 登录成功后的标准处理（带延迟和dismiss）
 * - safePresent/safeDismiss(): 安全的模态视图处理，防止重复操作
 * - navigationStackDepth/isAtTopOfNavigationStack(): 导航栈管理
 * 
 * 使用示例：
 * ```swift
 * // 登录成功后回到主页
 * handleLoginSuccess()
 * 
 * // 完成操作后回到根视图控制器
 * dismissToRootViewController { print("操作完成") }
 * 
 * // 安全地present视图控制器
 * safePresent(loginVC, animated: true)
 * ```
 */
extension UIViewController {
    
    // MARK: - 根视图控制器导航
    
    /**
     * Dismiss到根视图控制器
     * 
     * 确保无论从哪个模态页面都能正确回到根视图控制器
     * 常用于登录成功后回到主页的场景
     */
    func dismissToRootViewController() {
        // 获取根视图控制器
        guard let rootViewController = getRootViewController() else {
            // 如果找不到根视图控制器，直接dismiss当前页面
            dismiss(animated: true)
            return
        }
        
        // 如果当前页面是根视图控制器，不需要dismiss
        if self == rootViewController {
            return
        }
        
        // 如果根视图控制器正在呈现模态视图，dismiss所有模态视图
        if let presentedViewController = rootViewController.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        } else {
            // 直接dismiss当前页面
            dismiss(animated: true)
        }
    }
    
    /**
     * Dismiss到根视图控制器（带完成回调）
     * 
     * - Parameter completion: 完成后的回调
     */
    func dismissToRootViewController(completion: (() -> Void)? = nil) {
        // 获取根视图控制器
        guard let rootViewController = getRootViewController() else {
            // 如果找不到根视图控制器，直接dismiss当前页面
            dismiss(animated: true, completion: completion)
            return
        }
        
        // 如果当前页面是根视图控制器，直接执行完成回调
        if self == rootViewController {
            completion?()
            return
        }
        
        // 如果根视图控制器正在呈现模态视图，dismiss所有模态视图
        if let presentedViewController = rootViewController.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: completion)
        } else {
            // 直接dismiss当前页面
            dismiss(animated: true, completion: completion)
        }
    }
    
    // MARK: - 安全导航方法
    
    /**
     * 安全地present一个视图控制器
     * 
     * - Parameters:
     *   - viewController: 要present的视图控制器
     *   - animated: 是否动画
     *   - completion: 完成回调
     */
    func safePresent(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        // 检查是否已经有模态视图在呈现
        if presentedViewController != nil {
            print("[UIViewController+Navigation] 警告：已有模态视图在呈现，先dismiss")
            dismiss(animated: false) { [weak self] in
                self?.present(viewController, animated: animated, completion: completion)
            }
        } else {
            present(viewController, animated: animated, completion: completion)
        }
    }
    
    /**
     * 安全地dismiss当前视图控制器
     * 
     * - Parameters:
     *   - animated: 是否动画
     *   - completion: 完成回调
     */
    func safeDismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if isBeingPresented || isBeingDismissed {
            print("[UIViewController+Navigation] 警告：视图控制器正在被present或dismiss")
            return
        }
        
        dismiss(animated: animated, completion: completion)
    }
    
    // MARK: - 导航栈管理
    
    /**
     * 获取当前视图控制器在导航栈中的深度
     * 
     * - Returns: 导航栈深度，如果是根视图控制器返回0
     */
    func navigationStackDepth() -> Int {
        var depth = 0
        var currentVC: UIViewController? = self
        
        while let parent = currentVC?.parent {
            if parent is UINavigationController {
                depth += 1
            }
            currentVC = parent
        }
        
        return depth
    }
    
    /**
     * 检查是否在导航栈的顶部
     * 
     * - Returns: 是否在导航栈顶部
     */
    func isAtTopOfNavigationStack() -> Bool {
        guard let navigationController = navigationController else {
            return true // 如果没有导航控制器，认为是顶部
        }
        
        return navigationController.topViewController == self
    }
    
    // MARK: - 私有方法
    
    /**
     * 获取应用的根视图控制器
     * 
     * - Returns: 根视图控制器
     */
    private func getRootViewController() -> UIViewController? {
        // 优先使用iOS 13+的windowScene方式
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first { $0.isKeyWindow }?.rootViewController
        } else {
            // iOS 13以下使用传统方式
            return UIApplication.shared.keyWindow?.rootViewController
        }
    }
}

// MARK: - 登录相关导航扩展

/**
 * 登录相关的导航扩展
 */
extension UIViewController {
    
    /**
     * 登录成功后回到主页
     * 
     * 这是登录成功后的标准处理方式
     * - Parameter delay: 延迟时间，默认0.5秒
     */
    func handleLoginSuccess(delay: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.dismissToRootViewController()
        }
    }
    
    /**
     * 登录成功后回到主页（带完成回调）
     * 
     * - Parameters:
     *   - delay: 延迟时间，默认0.5秒
     *   - completion: 完成后的回调
     */
    func handleLoginSuccess(delay: TimeInterval = 0.5, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.dismissToRootViewController {
                completion()
            }
        }
    }
    
    /**
     * 登录成功后回到TabBar首页（适用于TabBar present Nav的导航结构）
     * 
     * 导航结构：TabBar首页 → present → Nav导航控制器 → root → 登录页面
     * 这个方法会直接dismiss整个模态导航栈，回到TabBar首页
     * 
     * - Parameter delay: 延迟时间，默认0.5秒
     */
    func handleLoginSuccessToTabBar(delay: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.dismissModalNavigationStack()
        }
    }
    
    /**
     * 登录成功后回到TabBar首页（带完成回调）
     * 
     * - Parameters:
     *   - delay: 延迟时间，默认0.5秒
     *   - completion: 完成后的回调
     */
    func handleLoginSuccessToTabBar(delay: TimeInterval = 0.5, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.dismissModalNavigationStack {
                completion()
            }
        }
    }
    
    /**
     * Dismiss模态导航栈
     * 
     * 适用于：TabBar首页 → present → Nav导航控制器 → 登录页面
     * 直接dismiss整个模态导航栈，回到TabBar首页
     * 
     * - Parameter completion: 完成后的回调
     */
    func dismissModalNavigationStack(completion: (() -> Void)? = nil) {
        print("[UIViewController+Navigation] 开始dismiss模态导航栈")
        
        // 如果当前页面有presentingViewController，说明是被模态present的
        if let presentingVC = presentingViewController {
            print("[UIViewController+Navigation] 找到presentingViewController，直接dismiss")
            presentingVC.dismiss(animated: true, completion: completion)
        } else {
            // 如果没有presentingViewController，尝试dismiss当前页面
            print("[UIViewController+Navigation] 没有找到presentingViewController，dismiss当前页面")
            dismiss(animated: true, completion: completion)
        }
    }
} 