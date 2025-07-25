//
//  Data+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's NSData+YYAdd.
//

import Foundation
import CommonCrypto
import Compression
import CryptoKit

extension Data {
    // MARK: - Hash
    func md5String() -> String {
        let digest = Insecure.MD5.hash(data: self)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func md5Data() -> Data {
        let digest = Insecure.MD5.hash(data: self)
        return Data(digest)
    }
    func sha1String() -> String {
        let digest = Insecure.SHA1.hash(data: self)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func sha1Data() -> Data {
        let digest = Insecure.SHA1.hash(data: self)
        return Data(digest)
    }
    func sha256String() -> String {
        let digest = SHA256.hash(data: self)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    func sha256Data() -> Data {
        let digest = SHA256.hash(data: self)
        return Data(digest)
    }
    func sha224String() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA224($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    // MARK: - HMAC
    func hmacSHA256String(key: Data) -> String {
        let keySym = SymmetricKey(data: key)
        let mac = HMAC<SHA256>.authenticationCode(for: self, using: keySym)
        return mac.map { String(format: "%02x", $0) }.joined()
    }
    func hmacSHA256Data(key: Data) -> Data {
        let keySym = SymmetricKey(data: key)
        let mac = HMAC<SHA256>.authenticationCode(for: self, using: keySym)
        return Data(mac)
    }
    // MARK: - AES256
    func aes256Encrypt(key: Data, iv: Data?) -> Data? {
        guard key.count == 16 || key.count == 24 || key.count == 32 else { return nil }
        let ivBytes = iv?.withUnsafeBytes { $0.baseAddress } ?? nil
        var outLength = 0
        var outBytes = [UInt8](repeating: 0, count: self.count + kCCBlockSizeAES128)
        let status = self.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES128), CCOptions(kCCOptionPKCS7Padding), keyBytes.baseAddress, key.count, ivBytes, dataBytes.baseAddress, self.count, &outBytes, outBytes.count, &outLength)
            }
        }
        guard status == kCCSuccess else { return nil }
        return Data(bytes: outBytes, count: outLength)
    }
    func aes256Decrypt(key: Data, iv: Data?) -> Data? {
        guard key.count == 16 || key.count == 24 || key.count == 32 else { return nil }
        let ivBytes = iv?.withUnsafeBytes { $0.baseAddress } ?? nil
        var outLength = 0
        var outBytes = [UInt8](repeating: 0, count: self.count + kCCBlockSizeAES128)
        let status = self.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES128), CCOptions(kCCOptionPKCS7Padding), keyBytes.baseAddress, key.count, ivBytes, dataBytes.baseAddress, self.count, &outBytes, outBytes.count, &outLength)
            }
        }
        guard status == kCCSuccess else { return nil }
        return Data(bytes: outBytes, count: outLength)
    }
    // MARK: - Encode/Decode
    func utf8String() -> String? {
        String(data: self, encoding: .utf8)
    }
    func hexString() -> String {
        self.map { String(format: "%02X", $0) }.joined()
    }
    static func dataWithHexString(_ hex: String) -> Data? {
        var hex = hex.replacingOccurrences(of: " ", with: "").lowercased()
        guard hex.count % 2 == 0 else { return nil }
        var data = Data(capacity: hex.count / 2)
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            if let b = UInt8(hex[index..<nextIndex], radix: 16) {
                data.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return data
    }
    func base64EncodedString() -> String {
        self.base64EncodedString()
    }
    static func dataWithBase64EncodedString(_ base64: String) -> Data? {
        Data(base64Encoded: base64)
    }
    func jsonValueDecoded() -> Any? {
        try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
    }
    // MARK: - Gzip/Zlib (需三方库或系统API支持，简单占位)
    // gzip/zlib 相关方法需三方库支持，如 GzipSwift/SwiftZip
    // func gzipDeflate() -> Data? { nil }
    // func gzipInflate() -> Data? { nil }
    // func zlibDeflate() -> Data? { nil }
    // func zlibInflate() -> Data? { nil }
    // MARK: - 文件加载
    static func dataNamed(_ name: String) -> Data? {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}

// MARK: - NSData Compression Helper
private extension NSData {
    func compressed(using algo: NSData.CompressionAlgorithm) -> Data? {
        if #available(iOS 13.0, *) {
            return (self as Data).compressed(using: algo)
        }
        return nil
    }
    func decompressed(using algo: NSData.CompressionAlgorithm) -> Data? {
        if #available(iOS 13.0, *) {
            return (self as Data).decompressed(using: algo)
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension Data {
    func compressed(using algo: NSData.CompressionAlgorithm) -> Data? {
        try? (self as NSData).compressed(using: algo) as Data
    }
    func decompressed(using algo: NSData.CompressionAlgorithm) -> Data? {
        try? (self as NSData).decompressed(using: algo) as Data
    }
} 