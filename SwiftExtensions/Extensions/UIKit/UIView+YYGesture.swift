import UIKit
import ObjectiveC

// MARK: - BlockTarget
private class _GestureBlockTarget: NSObject {
    let block: (UIView) -> Void
    init(_ block: @escaping (UIView) -> Void) { self.block = block }
    @objc func invoke(_ sender: UIGestureRecognizer) {
        if let view = sender.view { block(view) }
    }
}

// MARK: - Associated Keys
private var tapTargetsKey: Void?
private var longPressTargetsKey: Void?
private var panTargetsKey: Void?
private var swipeTargetsKey: Void?
private var pinchTargetsKey: Void?
private var rotationTargetsKey: Void?

// MARK: - UIView + YYKit风格手势扩展
extension UIView {
    // MARK: Tap
    func addTapAction(taps: Int = 1, touches: Int = 1, cancelsTouchesInView: Bool = true, block: @escaping (UIView) -> Void) {
        let target = _GestureBlockTarget(block)
        let gesture = UITapGestureRecognizer(target: target, action: #selector(_GestureBlockTarget.invoke(_:)))
        gesture.numberOfTapsRequired = taps
        gesture.numberOfTouchesRequired = touches
        gesture.cancelsTouchesInView = cancelsTouchesInView
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        _storeTarget(target, key: &tapTargetsKey)
    }
    func removeAllTapActions() {
        _removeAllActions(of: UITapGestureRecognizer.self, key: &tapTargetsKey)
    }
    // MARK: LongPress
    func addLongPressAction(minimumPressDuration: TimeInterval = 0.5, cancelsTouchesInView: Bool = true, block: @escaping (UIView) -> Void) {
        let target = _GestureBlockTarget(block)
        let gesture = UILongPressGestureRecognizer(target: target, action: #selector(_GestureBlockTarget.invoke(_:)))
        gesture.minimumPressDuration = minimumPressDuration
        gesture.cancelsTouchesInView = cancelsTouchesInView
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        _storeTarget(target, key: &longPressTargetsKey)
    }
    func removeAllLongPressActions() {
        _removeAllActions(of: UILongPressGestureRecognizer.self, key: &longPressTargetsKey)
    }
    // MARK: Pan
    func addPanAction(cancelsTouchesInView: Bool = true, block: @escaping (UIView) -> Void) {
        let target = _GestureBlockTarget(block)
        let gesture = UIPanGestureRecognizer(target: target, action: #selector(_GestureBlockTarget.invoke(_:)))
        gesture.cancelsTouchesInView = cancelsTouchesInView
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        _storeTarget(target, key: &panTargetsKey)
    }
    func removeAllPanActions() {
        _removeAllActions(of: UIPanGestureRecognizer.self, key: &panTargetsKey)
    }
    // MARK: Swipe
    func addSwipeAction(direction: UISwipeGestureRecognizer.Direction = .right, cancelsTouchesInView: Bool = true, block: @escaping (UIView) -> Void) {
        let target = _GestureBlockTarget(block)
        let gesture = UISwipeGestureRecognizer(target: target, action: #selector(_GestureBlockTarget.invoke(_:)))
        gesture.direction = direction
        gesture.cancelsTouchesInView = cancelsTouchesInView
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        _storeTarget(target, key: &swipeTargetsKey)
    }
    func removeAllSwipeActions() {
        _removeAllActions(of: UISwipeGestureRecognizer.self, key: &swipeTargetsKey)
    }
    // MARK: Pinch
    func addPinchAction(cancelsTouchesInView: Bool = true, block: @escaping (UIView) -> Void) {
        let target = _GestureBlockTarget(block)
        let gesture = UIPinchGestureRecognizer(target: target, action: #selector(_GestureBlockTarget.invoke(_:)))
        gesture.cancelsTouchesInView = cancelsTouchesInView
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        _storeTarget(target, key: &pinchTargetsKey)
    }
    func removeAllPinchActions() {
        _removeAllActions(of: UIPinchGestureRecognizer.self, key: &pinchTargetsKey)
    }
    // MARK: Rotation
    func addRotationAction(cancelsTouchesInView: Bool = true, block: @escaping (UIView) -> Void) {
        let target = _GestureBlockTarget(block)
        let gesture = UIRotationGestureRecognizer(target: target, action: #selector(_GestureBlockTarget.invoke(_:)))
        gesture.cancelsTouchesInView = cancelsTouchesInView
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        _storeTarget(target, key: &rotationTargetsKey)
    }
    func removeAllRotationActions() {
        _removeAllActions(of: UIRotationGestureRecognizer.self, key: &rotationTargetsKey)
    }
    // MARK: 通用移除
    func removeAllGestureActions() {
        removeAllTapActions()
        removeAllLongPressActions()
        removeAllPanActions()
        removeAllSwipeActions()
        removeAllPinchActions()
        removeAllRotationActions()
    }
    // MARK: - 私有存储与移除
    private func _storeTarget(_ target: _GestureBlockTarget, key: UnsafeRawPointer) {
        var targets = objc_getAssociatedObject(self, key) as? NSMutableArray
        if targets == nil {
            targets = NSMutableArray()
            objc_setAssociatedObject(self, key, targets!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        targets!.add(target)
    }
    private func _removeAllActions<T: UIGestureRecognizer>(of type: T.Type, key: UnsafeRawPointer) {
        gestureRecognizers?.forEach {
            if $0 is T { removeGestureRecognizer($0) }
        }
        objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - 用法示例
/*
view.addTapAction { v in print("tap: \(v)") }
view.addLongPressAction { v in print("long press: \(v)") }
view.addPanAction { v in print("pan: \(v)") }
view.addSwipeAction(direction: .left) { v in print("swipe left: \(v)") }
view.addPinchAction { v in print("pinch: \(v)") }
view.addRotationAction { v in print("rotation: \(v)") }
view.removeAllGestureActions()
*/ 