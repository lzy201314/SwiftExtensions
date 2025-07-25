import Foundation
import CommonCrypto
import UIKit

typealias UTF32Char = UInt32 // 补充类型别名

// MARK: - YYKit风格 String 扩展
extension String {
    // MARK: - 判空/去空格
    var isNotEmpty: Bool { !isEmpty }
    var isNotBlank: Bool {
        !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var removingAllSpaces: String { replacingOccurrences(of: " ", with: "") }
    // MARK: - 包含/正则
    func contains(_ other: String, options: String.CompareOptions = []) -> Bool {
        range(of: other, options: options) != nil
    }
    func containsCharacterSet(_ set: CharacterSet) -> Bool {
        rangeOfCharacter(from: set) != nil
    }
    func matches(_ pattern: String) -> Bool {
        range(of: pattern, options: .regularExpression) != nil
    }
    func replacing(pattern: String, with: String) -> String {
        replacingOccurrences(of: pattern, with: with, options: .regularExpression)
    }
    // MARK: - Base64
    var base64Encoded: String? { data(using: .utf8)?.base64EncodedString() }
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    // MARK: - Hash
    var md5: String { self.data(using: .utf8)?.md5String() ?? "" }
    var sha1: String { self.data(using: .utf8)?.sha1String() ?? "" }
    var sha224: String { self.data(using: .utf8)?.sha224String() ?? "" }
    var sha256: String { self.data(using: .utf8)?.sha256String() ?? "" }
    var sha384: String { self.data(using: .utf8)?.sha384String() ?? "" }
    var sha512: String { self.data(using: .utf8)?.sha512String() ?? "" }
    var crc32: String { self.data(using: .utf8)?.crc32String() ?? "" }
    // MARK: - HMAC
    func hmacMD5(key: String) -> String { self.data(using: .utf8)?.hmacMD5String(key: key) ?? "" }
    func hmacSHA1(key: String) -> String { self.data(using: .utf8)?.hmacSHA1String(key: key) ?? "" }
    func hmacSHA224(key: String) -> String { self.data(using: .utf8)?.hmacSHA224String(key: key) ?? "" }
    func hmacSHA256(key: String) -> String { self.data(using: .utf8)?.hmacSHA256String(key: key) ?? "" }
    func hmacSHA384(key: String) -> String { self.data(using: .utf8)?.hmacSHA384String(key: key) ?? "" }
    func hmacSHA512(key: String) -> String { self.data(using: .utf8)?.hmacSHA512String(key: key) ?? "" }
    // MARK: - URL/HTML
    var urlEncoded: String? { addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) }
    var urlDecoded: String? { removingPercentEncoding }
    var htmlEscaped: String {
        var result = ""
        for c in self {
            switch c {
            case "\"": result += "&quot;"
            case "&": result += "&amp;"
            case "'": result += "&apos;"
            case "<": result += "&lt;"
            case ">": result += "&gt;"
            default: result.append(c)
            }
        }
        return result
    }
    // MARK: - 文本绘制
    func size(for font: UIFont, size: CGSize, mode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        let attr: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle(); style.lineBreakMode = mode; return style
            }()
        ]
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attr, context: nil)
        return rect.size
    }
    func width(for font: UIFont) -> CGFloat {
        size(for: font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
    }
    func height(for font: UIFont, width: CGFloat) -> CGFloat {
        size(for: font, size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    // MARK: - NSNumber兼容
    var charValue: CChar { Int8(Int(self) ?? 0) }
    var unsignedCharValue: UInt8 { UInt8(Int(self) ?? 0) }
    var shortValue: Int16 { Int16(Int(self) ?? 0) }
    var unsignedShortValue: UInt16 { UInt16(Int(self) ?? 0) }
    var unsignedIntValue: UInt32 { UInt32(Int(self) ?? 0) }
    var longValue: Int { Int(self) ?? 0 }
    var unsignedLongValue: UInt { UInt(Int(self) ?? 0) }
    var unsignedLongLongValue: UInt64 { UInt64(Int(self) ?? 0) }
    var unsignedIntegerValue: UInt { UInt(Int(self) ?? 0) }
    // MARK: - UUID/UTF32/路径scale
    static func stringWithUUID() -> String { UUID().uuidString }
    static func stringWithUTF32Char(_ char32: UTF32Char) -> String? {
        var char32 = char32.littleEndian
        return withUnsafeBytes(of: &char32) { rawPtr in
            String(bytes: rawPtr, encoding: .utf32LittleEndian)
        }
    }
    static func stringWithUTF32Chars(_ chars: [UTF32Char]) -> String? {
        var chars = chars.map { $0.littleEndian }
        return withUnsafeBytes(of: &chars) { rawPtr in
            String(bytes: rawPtr, encoding: .utf32LittleEndian)
        }
    }
    func pathScale() -> CGFloat {
        let regex = "@[0-9]+\\.?[0-9]*x$"
        guard let match = self.range(of: regex, options: .regularExpression) else { return 1 }
        let scaleStr = self[match].dropFirst().dropLast()
        return CGFloat(Double(scaleStr) ?? 1)
    }
    // MARK: - 其它
    func substring(from: Int, length: Int) -> String {
        guard from >= 0, length > 0, from < count else { return "" }
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: min(length, count-from), limitedBy: endIndex) ?? endIndex
        return String(self[start..<end])
    }
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    var jsonObject: Any? {
        guard let data = data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    var capitalizedFirst: String {
        prefix(1).capitalized + dropFirst()
    }
    var isNumeric: Bool { !isEmpty && range(of: "^[0-9]+$", options: .regularExpression) != nil }
    static func stringNamed(_ name: String) -> String? {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) ?? Bundle.main.path(forResource: name, ofType: "txt") else { return nil }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}

// MARK: - Data/Hash/HMAC辅助
private extension Data {
    /*
    func md5String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        withUnsafeBytes { CC_MD5($0.baseAddress, CC_LONG(count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func sha1String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        withUnsafeBytes { CC_SHA1($0.baseAddress, CC_LONG(count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func sha224String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
        withUnsafeBytes { CC_SHA224($0.baseAddress, CC_LONG(count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func sha256String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes { CC_SHA256($0.baseAddress, CC_LONG(count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
     */
    func sha384String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
        withUnsafeBytes { CC_SHA384($0.baseAddress, CC_LONG(count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func sha512String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        withUnsafeBytes { CC_SHA512($0.baseAddress, CC_LONG(count), &digest) }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func crc32String() -> String {
        var crc: UInt32 = 0xffffffff
        for byte in self { crc = (crc >> 8) ^ crc32tab[Int((crc ^ UInt32(byte)) & 0xff)] }
        return String(format: "%08x", crc ^ 0xffffffff)
    }
    func hmacMD5String(key: String) -> String {
        let keyData = key.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        withUnsafeBytes { dataPtr in
            keyData.withUnsafeBytes { keyPtr in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgMD5), keyPtr.baseAddress, keyData.count, dataPtr.baseAddress, count, &digest)
            }
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func hmacSHA1String(key: String) -> String {
        let keyData = key.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        withUnsafeBytes { dataPtr in
            keyData.withUnsafeBytes { keyPtr in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyPtr.baseAddress, keyData.count, dataPtr.baseAddress, count, &digest)
            }
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func hmacSHA224String(key: String) -> String {
        let keyData = key.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
        withUnsafeBytes { dataPtr in
            keyData.withUnsafeBytes { keyPtr in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA224), keyPtr.baseAddress, keyData.count, dataPtr.baseAddress, count, &digest)
            }
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func hmacSHA256String(key: String) -> String {
        let keyData = key.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes { dataPtr in
            keyData.withUnsafeBytes { keyPtr in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyPtr.baseAddress, keyData.count, dataPtr.baseAddress, count, &digest)
            }
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func hmacSHA384String(key: String) -> String {
        let keyData = key.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
        withUnsafeBytes { dataPtr in
            keyData.withUnsafeBytes { keyPtr in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA384), keyPtr.baseAddress, keyData.count, dataPtr.baseAddress, count, &digest)
            }
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func hmacSHA512String(key: String) -> String {
        let keyData = key.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        withUnsafeBytes { dataPtr in
            keyData.withUnsafeBytes { keyPtr in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), keyPtr.baseAddress, keyData.count, dataPtr.baseAddress, count, &digest)
            }
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

// CRC32查表
private let crc32tab: [UInt32] = {
    (0...255).map { i -> UInt32 in
        var c = UInt32(i)
        for _ in 0..<8 { c = (c & 1) != 0 ? (0xedb88320 ^ (c >> 1)) : (c >> 1) }
        return c
    }
}() 
