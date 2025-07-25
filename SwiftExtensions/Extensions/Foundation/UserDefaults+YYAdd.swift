//
//  UserDefaults+YYAdd.swift
//  tongshengbao_cn
//
//  Created by AI for UserDefaults/Codable/JSON convenience extensions.
//

import Foundation

public extension UserDefaults {
    /// 存储 Codable 模型
    func setCodable<T: Codable>(_ value: T?, forKey key: String) {
        guard let value = value else {
            removeObject(forKey: key)
            return
        }
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(value) {
            set(data, forKey: key)
        }
    }
    /// 读取 Codable 模型
    func codable<T: Codable>(forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    /// 存储 Codable 数组
    func setCodableArray<T: Codable>(_ value: [T]?, forKey key: String) {
        setCodable(value, forKey: key)
    }
    /// 读取 Codable 数组
    func codableArray<T: Codable>(forKey key: String) -> [T]? {
        codable(forKey: key)
    }
}

public extension Encodable {
    /// 转 JSON 字符串
    func toJSONString(pretty: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if pretty { encoder.outputFormatting = .prettyPrinted }
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

public extension Decodable {
    /// 从 JSON 字符串解码
    static func fromJSONString(_ json: String) -> Self? {
        guard let data = json.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
} 