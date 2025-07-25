import Foundation

// MARK: - YYKit风格 Dictionary 扩展
extension Dictionary where Key == String {
    // MARK: - Plist/XML序列化
    static func dictionaryWithPlistData(_ plist: Data) -> [String: Any]? {
        (try? PropertyListSerialization.propertyList(from: plist, options: [], format: nil)) as? [String: Any]
    }
    static func dictionaryWithPlistString(_ plist: String) -> [String: Any]? {
        guard let data = plist.data(using: .utf8) else { return nil }
        return dictionaryWithPlistData(data)
    }
    func plistData() -> Data? {
        try? PropertyListSerialization.data(fromPropertyList: self, format: .binary, options: 0)
    }
    func plistString() -> String? {
        guard let data = try? PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: 0) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    // MARK: - 排序/筛选
    func allKeysSorted() -> [String] {
        keys.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }
    func allValuesSortedByKeys() -> [Any] {
        allKeysSorted().compactMap { self[$0] }
    }
    func containsObject(forKey key: String) -> Bool {
        self[key] != nil
    }
    func entries(forKeys keys: [String]) -> [String: Any] {
        var dic = [String: Any]()
        for key in keys { if let v = self[key] { dic[key] = v } }
        return dic
    }
    // MARK: - JSON序列化
    func jsonStringEncoded() -> String? {
        guard JSONSerialization.isValidJSONObject(self),
              let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    func jsonPrettyStringEncoded() -> String? {
        guard JSONSerialization.isValidJSONObject(self),
              let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    // MARK: - 类型安全获取
    func boolValue(forKey key: String, default def: Bool = false) -> Bool {
        if let v = self[key] as? Bool { return v }
        if let v = self[key] as? String { return (v as NSString).boolValue }
        if let v = self[key] as? NSNumber { return v.boolValue }
        return def
    }
    func intValue(forKey key: String, default def: Int = 0) -> Int {
        if let v = self[key] as? Int { return v }
        if let v = self[key] as? String { return Int(v) ?? def }
        if let v = self[key] as? NSNumber { return v.intValue }
        return def
    }
    func doubleValue(forKey key: String, default def: Double = 0) -> Double {
        if let v = self[key] as? Double { return v }
        if let v = self[key] as? String { return Double(v) ?? def }
        if let v = self[key] as? NSNumber { return v.doubleValue }
        return def
    }
    func stringValue(forKey key: String, default def: String = "") -> String {
        if let v = self[key] as? String { return v }
        if let v = self[key] as? NSNumber { return v.stringValue }
        return def
    }
    func numberValue(forKey key: String, default def: NSNumber? = nil) -> NSNumber? {
        if let v = self[key] as? NSNumber { return v }
        if let v = self[key] as? String, let n = NumberFormatter().number(from: v) { return n }
        return def
    }
    /// 深拷贝：递归拷贝所有嵌套结构，元素需实现NSCopying或为值类型
    func deepCopy() -> [String: Any] {
        var result = [String: Any]()
        for (key, value) in self {
            if let copyable = value as? NSCopying {
                result[key] = copyable.copy(with: nil)
            } else if let arr = value as? [Any] {
                result[key] = (arr as NSArray).deepCopy()
            } else if let dict = value as? [String: Any] {
                result[key] = dict.deepCopy()
            } else {
                result[key] = value
            }
        }
        return result
    }
}

// MARK: - 可变字典扩展
extension Dictionary where Key == String, Value: Any {
    mutating func popObject(forKey key: String) -> Value? {
        guard let v = self[key] else { return nil }
        self.removeValue(forKey: key)
        return v
    }
    mutating func popEntries(forKeys keys: [String]) -> [String: Value] {
        var dic = [String: Value]()
        for key in keys {
            if let v = self.popObject(forKey: key) {
                dic[key] = v
            }
        }
        return dic
    }
} 