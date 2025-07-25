import Foundation

// MARK: - YYKit风格 Array 扩展
extension Array {
    // MARK: - Plist序列化
    static func arrayWithPlistData(_ plist: Data) -> [Element]? {
        (try? PropertyListSerialization.propertyList(from: plist, options: [], format: nil)) as? [Element]
    }
    static func arrayWithPlistString(_ plist: String) -> [Element]? {
        guard let data = plist.data(using: .utf8) else { return nil }
        return arrayWithPlistData(data)
    }
    func plistData() -> Data? {
        try? PropertyListSerialization.data(fromPropertyList: self, format: .binary, options: 0)
    }
    func plistString() -> String? {
        guard let data = try? PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: 0) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    // MARK: - 随机/安全取值
    var randomObject: Element? {
        guard !isEmpty else { return nil }
        return self[Int.random(in: 0..<count)]
    }
    func objectOrNil(at index: Int) -> Element? {
        (0..<count).contains(index) ? self[index] : nil
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
    /// 深拷贝：元素需实现NSCopying或为值类型
    func yy_deepCopyArray() -> [Element] {
        return self.map { element in
            if let copyable = element as? NSCopying {
                return copyable.copy(with: nil) as! Element
            } else if let arr = element as? [Any] {
                // 递归拷贝嵌套数组
                return (arr as NSArray).copy() as! Element
            } else if let dict = element as? [String: Any] {
                return (dict as NSDictionary).copy() as! Element
            } else {
                return element // 值类型或无法拷贝的对象直接返回
            }
        }
    }
}

// MARK: - 可变数组扩展
extension Array {
    @discardableResult
    mutating func popFirstObject() -> Element? {
        guard !isEmpty else { return nil }
        return removeFirst()
    }
    @discardableResult
    mutating func popLastObject() -> Element? {
        guard !isEmpty else { return nil }
        return removeLast()
    }
    mutating func appendObject(_ obj: Element) {
        append(obj)
    }
    mutating func prependObject(_ obj: Element) {
        insert(obj, at: 0)
    }
    mutating func appendObjects(_ objs: [Element]) {
        append(contentsOf: objs)
    }
    mutating func prependObjects(_ objs: [Element]) {
        insert(contentsOf: objs, at: 0)
    }
    mutating func insertObjects(_ objs: [Element], at index: Int) {
        var idx = index
        for obj in objs {
            insert(obj, at: idx)
            idx += 1
        }
    }
    mutating func reverseArray() {
        self = reversed()
    }
    mutating func shuffleArray() {
        self = shuffled()
    }
} 