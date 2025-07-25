//
//  UIFont+DebugExtension.swift
//  tongshengbao_cn
//
//  Created by 陆志勇 on 2025/6/26.
//

import UIKit

// MARK: - UIFont 调试扩展
extension UIFont {
    
    /// 打印系统所有字体族（调试用）
    static func printSystemFontFamilies() {
        // 打印系统所有字体族
        print("=== 系统字体族列表 ===")
        let fontFamilies = UIFont.familyNames.sorted()
        for (index, familyName) in fontFamilies.enumerated() {
            print("\(index + 1). \(familyName)")
            
            // 打印每个字体族下的具体字体
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for fontName in fontNames {
                print("   - \(fontName)")
            }
        }
        print("=== 字体族总数: \(fontFamilies.count) ===")
        
        // 特别检查PingFang SC字体
        print("\n=== PingFang SC 字体检查 ===")
        let pingFangFonts = UIFont.fontNames(forFamilyName: "PingFang SC")
        if pingFangFonts.isEmpty {
            print("❌ PingFang SC 字体族不存在")
        } else {
            print("✅ PingFang SC 字体族存在，包含以下字体:")
            for fontName in pingFangFonts {
                print("   - \(fontName)")
            }
        }
        
        // 检查PingFangSC字体
        print("\n=== PingFangSC 字体检查 ===")
        let pingFangSCFonts = UIFont.fontNames(forFamilyName: "PingFangSC")
        if pingFangSCFonts.isEmpty {
            print("❌ PingFangSC 字体族不存在")
        } else {
            print("✅ PingFangSC 字体族存在，包含以下字体:")
            for fontName in pingFangSCFonts {
                print("   - \(fontName)")
            }
        }
        
        // 检查系统默认字体
        print("\n=== 系统默认字体检查 ===")
        let systemFont = UIFont.systemFont(ofSize: 16)
        print("系统默认字体: \(systemFont.fontName)")
        print("系统默认字体族: \(systemFont.familyName)")
        
        let boldSystemFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        print("系统粗体字体: \(boldSystemFont.fontName)")
        print("系统粗体字体族: \(boldSystemFont.familyName)")
    }
    
    /// 检查指定字体是否存在
    /// - Parameter fontName: 字体名称
    /// - Returns: 是否存在
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
    
    /// 检查指定字体族是否存在
    /// - Parameter familyName: 字体族名称
    /// - Returns: 是否存在
    static func isFontFamilyAvailable(_ familyName: String) -> Bool {
        return UIFont.familyNames.contains(familyName)
    }
    
    /// 获取指定字体族下的所有字体名称
    /// - Parameter familyName: 字体族名称
    /// - Returns: 字体名称数组
    static func getFontNames(forFamily familyName: String) -> [String] {
        return UIFont.fontNames(forFamilyName: familyName)
    }
    
    /// 打印指定字体族的详细信息
    /// - Parameter familyName: 字体族名称
    static func printFontFamilyDetails(_ familyName: String) {
        print("=== \(familyName) 字体族详细信息 ===")
        
        if isFontFamilyAvailable(familyName) {
            print("✅ 字体族存在")
            let fontNames = getFontNames(forFamily: familyName)
            print("包含 \(fontNames.count) 个字体:")
            
            for (index, fontName) in fontNames.enumerated() {
                print("  \(index + 1). \(fontName)")
                
                // 测试字体是否可用
                if let font = UIFont(name: fontName, size: 16) {
                    print("     ✅ 可用 - 字体名: \(font.fontName), 族名: \(font.familyName)")
                } else {
                    print("     ❌ 不可用")
                }
            }
        } else {
            print("❌ 字体族不存在")
        }
        print("================================")
    }
    
    /// 打印当前字体的详细信息
    func printFontDetails() {
        print("=== 字体详细信息 ===")
        print("字体名称: \(self.fontName)")
        print("字体族名: \(self.familyName)")
        print("字体大小: \(self.pointSize)")
        print("字体描述: \(self.fontDescriptor)")
        print("行高: \(self.lineHeight)")
        print("上升部: \(self.ascender)")
        print("下降部: \(self.descender)")
        print("大写字母高度: \(self.capHeight)")
        print("x高度: \(self.xHeight)")
        print("==================")
    }
    
    /// 测试字体创建是否成功
    /// - Parameters:
    ///   - name: 字体名称
    ///   - size: 字体大小
    /// - Returns: 创建结果
    static func testFontCreation(name: String, size: CGFloat = 16) -> (success: Bool, font: UIFont?) {
        let font = UIFont(name: name, size: size)
        let success = font != nil
        
        print("字体测试: \(name)")
        print("  大小: \(size)")
        print("  结果: \(success ? "✅ 成功" : "❌ 失败")")
        
        if let font = font {
            print("  实际字体名: \(font.fontName)")
            print("  字体族名: \(font.familyName)")
        }
        
        return (success, font)
    }
    
    /// 批量测试字体创建
    /// - Parameter fontNames: 字体名称数组
    static func batchTestFontCreation(_ fontNames: [String], size: CGFloat = 16) {
        print("=== 批量字体测试 ===")
        print("测试大小: \(size)")
        print("测试字体数量: \(fontNames.count)")
        print("")
        
        var successCount = 0
        var failCount = 0
        
        for fontName in fontNames {
            let result = testFontCreation(name: fontName, size: size)
            if result.success {
                successCount += 1
            } else {
                failCount += 1
            }
            print("")
        }
        
        print("=== 测试结果汇总 ===")
        print("成功: \(successCount)")
        print("失败: \(failCount)")
        print("成功率: \(String(format: "%.1f%%", Double(successCount) / Double(fontNames.count) * 100))")
        print("==================")
    }
}

// MARK: - 便捷调试方法
extension UIFont {
    
    /// 快速检查PingFang SC字体
    static func checkPingFangSCFonts() {
        print("=== PingFang SC 字体快速检查 ===")
        
        let pingFangFonts = [
            "PingFangSC-Regular",
            "PingFangSC-Medium", 
            "PingFangSC-Semibold",
            "PingFangSC-Light",
            "PingFangSC-Ultralight",
            "PingFangSC-Thin"
        ]
        
        batchTestFontCreation(pingFangFonts)
    }
    
    /// 快速检查系统常用字体
    static func checkSystemCommonFonts() {
        print("=== 系统常用字体快速检查 ===")
        
        let commonFonts = [
            "Helvetica",
            "HelveticaNeue",
            "Arial",
            "Times New Roman",
            "Georgia",
            "Verdana",
            "Courier New"
        ]
        
        batchTestFontCreation(commonFonts)
    }
}

/*
// =================== 使用示例 ===================

// 1. 打印所有系统字体族
UIFont.printSystemFontFamilies()

// 2. 检查特定字体是否存在
let isPingFangAvailable = UIFont.isFontAvailable("PingFangSC-Regular")
print("PingFangSC-Regular 是否可用: \(isPingFangAvailable)")

// 3. 检查字体族是否存在
let isPingFangFamilyAvailable = UIFont.isFontFamilyAvailable("PingFang SC")
print("PingFang SC 字体族是否可用: \(isPingFangFamilyAvailable)")

// 4. 获取字体族下的所有字体
let pingFangFonts = UIFont.getFontNames(forFamily: "PingFang SC")
print("PingFang SC 字体族包含: \(pingFangFonts)")

// 5. 打印字体族详细信息
UIFont.printFontFamilyDetails("PingFang SC")

// 6. 打印当前字体详细信息
let font = UIFont.systemFont(ofSize: 16)
font.printFontDetails()

// 7. 测试字体创建
let result = UIFont.testFontCreation(name: "PingFangSC-Regular", size: 16)
if result.success {
    print("字体创建成功")
} else {
    print("字体创建失败")
}

// 8. 批量测试字体
let fontsToTest = ["PingFangSC-Regular", "PingFangSC-Medium", "PingFangSC-Semibold"]
UIFont.batchTestFontCreation(fontsToTest)

// 9. 快速检查PingFang SC字体
UIFont.checkPingFangSCFonts()

// 10. 快速检查系统常用字体
UIFont.checkSystemCommonFonts()

// ==============================================
*/ 