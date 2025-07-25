//
//  NSObject+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSObject+YYAdd.
//

import Foundation
import ObjectiveC

extension NSObject {
    // MARK: - Associate value
    func setAssociateValue(_ value: Any?, withKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func setAssociateWeakValue(_ value: AnyObject?, withKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
    func getAssociatedValue(forKey key: UnsafeRawPointer) -> Any? {
        objc_getAssociatedObject(self, key)
    }
    func removeAssociatedValues() {
        objc_removeAssociatedObjects(self)
    }
    // MARK: - Class name
    class var className: String {
        String(describing: self)
    }
    var className: String {
        String(describing: type(of: self))
    }
    // MARK: - Deep Copy
    func deepCopy() -> AnyObject? {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false) else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as AnyObject?
    }
    func deepCopyWithArchiver<A: NSKeyedArchiver, U: NSKeyedUnarchiver>(_ archiver: A.Type, _ unarchiver: U.Type) -> AnyObject? {
        guard let data = try? archiver.archivedData(withRootObject: self, requiringSecureCoding: false) else { return nil }
        return try? unarchiver.unarchiveTopLevelObjectWithData(data) as AnyObject?
    }
    // MARK: - Method Swizzling
    @discardableResult
    class func swizzleInstanceMethod(_ originalSel: Selector, with newSel: Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(self, originalSel),
              let newMethod = class_getInstanceMethod(self, newSel) else { return false }
        method_exchangeImplementations(originalMethod, newMethod)
        return true
    }
    @discardableResult
    class func swizzleClassMethod(_ originalSel: Selector, with newSel: Selector) -> Bool {
        guard let metaclass = object_getClass(self),
              let originalMethod = class_getClassMethod(self, originalSel),
              let newMethod = class_getClassMethod(self, newSel) else { return false }
        method_exchangeImplementations(originalMethod, newMethod)
        return true
    }
} 