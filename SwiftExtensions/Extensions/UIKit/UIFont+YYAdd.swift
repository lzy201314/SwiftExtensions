//
//  UIFont+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIFont+YYAdd.
//

import UIKit
import CoreText

extension UIFont {
    // MARK: - Font Traits
    var isBold: Bool {
        fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    var isItalic: Bool {
        fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    var isMonoSpace: Bool {
        fontDescriptor.symbolicTraits.contains(.traitMonoSpace)
    }
    var isColorGlyphs: Bool {
        guard let ctFont = self.ctFont else { return false }
        return CTFontGetSymbolicTraits(ctFont).contains(.traitColorGlyphs)
    }
    var fontWeight: CGFloat {
        (fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any])?[.weight] as? CGFloat ?? 0
    }
    // MARK: - Font Transform
    func fontWithBold() -> UIFont? {
        return withTraits(.traitBold)
    }
    func fontWithItalic() -> UIFont? {
        return withTraits(.traitItalic)
    }
    func fontWithBoldItalic() -> UIFont? {
        return withTraits([.traitBold, .traitItalic])
    }
    func fontWithNormal() -> UIFont? {
        return withTraits([])
    }
    private func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont? {
        guard let desc = fontDescriptor.withSymbolicTraits(traits) else { return nil }
        return UIFont(descriptor: desc, size: pointSize)
    }
    // MARK: - CTFont/CGFont 互转
    var ctFont: CTFont? {
        CTFontCreateWithName(fontName as CFString, pointSize, nil)
    }
    var cgFont: CGFont? {
        CGFont(fontName as CFString)
    }
    static func font(withCTFont ctFont: CTFont) -> UIFont? {
        let name = CTFontCopyPostScriptName(ctFont) as String
        let size = CTFontGetSize(ctFont)
        return UIFont(name: name, size: size)
    }
    static func font(withCGFont cgFont: CGFont, size: CGFloat) -> UIFont? {
        let name = cgFont.postScriptName as String? ?? ""
        return UIFont(name: name, size: size)
    }
    // MARK: - 字体文件/数据加载与卸载
    @discardableResult
    static func loadFont(fromPath path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(url as CFURL, .none, &error)
        if !success, let error = error?.takeRetainedValue() {
            print("Failed to load font: \(error)")
        }
        return success
    }
    static func unloadFont(fromPath path: String) {
        let url = URL(fileURLWithPath: path)
        CTFontManagerUnregisterFontsForURL(url as CFURL, .none, nil)
    }
    static func loadFont(fromData data: Data) -> UIFont? {
        guard let provider = CGDataProvider(data: data as CFData),
              let cgFont = CGFont(provider) else { return nil }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(cgFont, &error)
        if !success {
            if let error = error?.takeRetainedValue() {
                print(error)
            }
            return nil
        }
        let name = cgFont.postScriptName as String? ?? ""
        return UIFont(name: name, size: UIFont.systemFontSize)
    }
    @discardableResult
    static func unloadFont(fromData font: UIFont) -> Bool {
        guard let cgFont = font.cgFont else { return false }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerUnregisterGraphicsFont(cgFont, &error)
        if !success, let error = error?.takeRetainedValue() {
            print(error)
        }
        return success
    }
    // MARK: - 字体数据导出
    static func data(fromFont font: UIFont) -> Data? {
        guard let cgFont = font.cgFont else { return nil }
        return data(fromCGFont: cgFont)
    }
    static func data(fromCGFont cgFont: CGFont) -> Data? {
        guard let tags = cgFont.tableTags as? [NSNumber] else { return nil }
        var data = Data()
        for tagNum in tags {
            let tag = tagNum.uint32Value
            if let table = cgFont.table(for: tag) {
                data.append(table as Data)
            }
        }
        return data.isEmpty ? nil : data
    }
} 