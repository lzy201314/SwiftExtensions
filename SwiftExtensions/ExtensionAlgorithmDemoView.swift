import SwiftUI

// 确保你的扩展已在项目中可用（如已 import Foundation/Other/Algorithm+YYAdd.swift）

struct ExtensionAlgorithmDemoView: View {
    struct DemoItem: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let code: String
        let test: () -> String
    }
    
    @State private var output: String = ""
    
    let demos: [DemoItem] = [
        // Array 扩展
        DemoItem(
            title: "冒泡排序 (bubbleSorted)",
            description: "对数组进行冒泡排序，返回排序后的新数组。",
            code: "let arr = [3, 1, 2]\nlet sorted = arr.bubbleSorted() // [1, 2, 3]",
            test: {
                let arr = [3, 1, 2]
                let sorted = arr.bubbleSorted()
                return """
输入: [3, 1, 2]
输出: \(sorted)
"""
            }
        ),
        DemoItem(
            title: "快速排序 (quickSorted)",
            description: "对数组进行快速排序，返回排序后的新数组。",
            code: "let arr = [5, 2, 8, 1]\nlet sorted = arr.quickSorted() // [1, 2, 5, 8]",
            test: {
                let arr = [5, 2, 8, 1]
                let sorted = arr.quickSorted()
                return """
输入: [5, 2, 8, 1]
输出: \(sorted)
"""
            }
        ),
        DemoItem(
            title: "归并排序 (mergeSorted)",
            description: "对数组进行归并排序，返回排序后的新数组。",
            code: "let arr = [4, 2, 7, 1]\nlet sorted = arr.mergeSorted() // [1, 2, 4, 7]",
            test: {
                let arr = [4, 2, 7, 1]
                let sorted = arr.mergeSorted()
                return """
输入: [4, 2, 7, 1]
输出: \(sorted)
"""
            }
        ),
        DemoItem(
            title: "插入排序 (insertionSorted)",
            description: "对数组进行插入排序，返回排序后的新数组。",
            code: "let arr = [4, 2, 7, 1]\nlet sorted = arr.insertionSorted() // [1, 2, 4, 7]",
            test: {
                let arr = [4, 2, 7, 1]
                let sorted = arr.insertionSorted()
                return """
输入: [4, 2, 7, 1]
输出: \(sorted)
"""
            }
        ),
        DemoItem(
            title: "选择排序 (selectionSorted)",
            description: "对数组进行选择排序，返回排序后的新数组。",
            code: "let arr = [9, 3, 6, 2]\nlet sorted = arr.selectionSorted() // [2, 3, 6, 9]",
            test: {
                let arr = [9, 3, 6, 2]
                let sorted = arr.selectionSorted()
                return """
输入: [9, 3, 6, 2]
输出: \(sorted)
"""
            }
        ),
        DemoItem(
            title: "二分查找 (binarySearch)",
            description: "在有序数组中查找目标元素，返回索引或 nil。",
            code: "let arr = [1, 2, 3, 4, 5]\nlet index = arr.binarySearch(3) // 2",
            test: {
                let arr = [1, 2, 3, 4, 5]
                let index = arr.binarySearch(3)
                let output = index.map { String($0) } ?? "nil"
                return """
输入: [1, 2, 3, 4, 5], 查找: 3
输出: \(output)
"""
            }
        ),
        DemoItem(
            title: "线性查找 (linearSearch)",
            description: "在数组中查找目标元素，返回索引或 nil。",
            code: "let arr = [10, 20, 30]\nlet index = arr.linearSearch(20) // 1",
            test: {
                let arr = [10, 20, 30]
                let index = arr.linearSearch(20)
                let output = index.map { String($0) } ?? "nil"
                return """
输入: [10, 20, 30], 查找: 20
输出: \(output)
"""
            }
        ),
        DemoItem(
            title: "去重 (unique)",
            description: "返回去重后的新数组。",
            code: "let arr = [1, 2, 2, 3]\nlet uniqueArr = arr.unique() // [1, 2, 3]",
            test: {
                let arr = [1, 2, 2, 3]
                let uniqueArr = arr.unique()
                return """
输入: [1, 2, 2, 3]
输出: \(uniqueArr)
"""
            }
        ),
        DemoItem(
            title: "全排列 (permutations)",
            description: "返回数组的所有排列组合。",
            code: "let arr = [1, 2, 3]\nlet perms = arr.permutations() // [[1,2,3],[1,3,2],...]",
            test: {
                let arr = [1, 2, 3]
                let perms = arr.permutations()
                return """
输入: [1, 2, 3]
输出: \(perms.prefix(3))... 共\(perms.count)种
"""
            }
        ),
        DemoItem(
            title: "子集生成 (subsets)",
            description: "返回数组的所有子集。",
            code: "let arr = [1, 2, 3]\nlet subs = arr.subsets() // [[], [1], [2], [1,2], ...]",
            test: {
                let arr = [1, 2, 3]
                let subs = arr.subsets()
                return """
输入: [1, 2, 3]
输出: \(subs.prefix(4))... 共\(subs.count)种
"""
            }
        ),
        // String 扩展
        DemoItem(
            title: "回文字符串 (isPalindrome)",
            description: "判断字符串是否为回文。",
            code: "let str = \"level\"\nlet isPalin = str.isPalindrome // true",
            test: {
                let str = "level"
                let isPalin = str.isPalindrome
                return """
输入: "level"
输出: \(isPalin)
"""
            }
        ),
        DemoItem(
            title: "字符出现次数 (count(of:))",
            description: "统计某个字符在字符串中出现的次数。",
            code: "let str = \"banana\"\nlet count = str.count(of: \"a\") // 3",
            test: {
                let str = "banana"
                let count = str.count(of: "a")
                return """
输入: "banana", 字符: "a"
输出: \(count)
"""
            }
        ),
        DemoItem(
            title: "字符串反转 (reversedString)",
            description: "返回字符串的反转结果。",
            code: "let str = \"hello\"\nlet rev = str.reversedString // \"olleh\"",
            test: {
                let str = "hello"
                let rev = str.reversedString
                return """
输入: "hello"
输出: "\(rev)"
"""
            }
        ),
        DemoItem(
            title: "最长公共前缀 (longestCommonPrefix)",
            description: "返回字符串数组的最长公共前缀。",
            code: "let prefix = String.longestCommonPrefix([\"flower\",\"flow\",\"flight\"]) // \"fl\"",
            test: {
                let arr = ["flower","flow","flight"]
                let prefix = String.longestCommonPrefix(arr)
                return """
输入: \(arr)
输出: "\(prefix)"
"""
            }
        ),
        DemoItem(
            title: "KMP字符串查找 (kmpSearch)",
            description: "KMP 算法查找 pattern 在字符串中首次出现的位置。",
            code: "let str = \"ababcabcacbab\"\nlet idx = str.kmpSearch(\"abcac\") // 5",
            test: {
                let str = "ababcabcacbab"
                let idx = str.kmpSearch("abcac")
                return """
输入: "ababcabcacbab", pattern: "abcac"
输出: \(idx)
"""
            }
        ),
        // Int 扩展
        DemoItem(
            title: "质数判断 (isPrime)",
            description: "判断整数是否为质数。",
            code: "let isPrime = 17.isPrime // true",
            test: {
                let n = 17
                let isPrime = n.isPrime
                return """
输入: 17
输出: \(isPrime)
"""
            }
        ),
        DemoItem(
            title: "阶乘 (factorial)",
            description: "计算整数的阶乘。",
            code: "let fact = 5.factorial // 120",
            test: {
                let n = 5
                let fact = n.factorial
                return """
输入: 5
输出: \(fact)
"""
            }
        ),
        DemoItem(
            title: "回文数判断 (isPalindromeNumber)",
            description: "判断整数是否为回文数。",
            code: "let isPalNum = 121.isPalindromeNumber // true",
            test: {
                let n = 121
                let isPalNum = n.isPalindromeNumber
                return """
输入: 121
输出: \(isPalNum)
"""
            }
        ),
        // AlgorithmUtils 静态方法
        DemoItem(
            title: "斐波那契数列 (AlgorithmUtils.fibonacci)",
            description: "计算斐波那契数列的第 n 项。",
            code: "let fib = AlgorithmUtils.fibonacci(10) // 55",
            test: {
                let fib = AlgorithmUtils.fibonacci(10)
                return """
输入: 10
输出: \(fib)
"""
            }
        ),
        DemoItem(
            title: "最大公约数 (AlgorithmUtils.gcd)",
            description: "计算两个数的最大公约数。",
            code: "let g = AlgorithmUtils.gcd(24, 36) // 12",
            test: {
                let g = AlgorithmUtils.gcd(24, 36)
                return """
输入: 24, 36
输出: \(g)
"""
            }
        ),
        DemoItem(
            title: "最小公倍数 (AlgorithmUtils.lcm)",
            description: "计算两个数的最小公倍数。",
            code: "let l = AlgorithmUtils.lcm(6, 8) // 24",
            test: {
                let l = AlgorithmUtils.lcm(6, 8)
                return """
输入: 6, 8
输出: \(l)
"""
            }
        ),
        DemoItem(
            title: "快速幂 (AlgorithmUtils.fastPower)",
            description: "计算 base^exp % mod 的结果。",
            code: "let pow = AlgorithmUtils.fastPower(2, 10, 1000) // 24",
            test: {
                let pow = AlgorithmUtils.fastPower(2, 10, 1000)
                return """
输入: 2, 10, 1000
输出: \(pow)
"""
            }
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("扩展算法演示")
                    .font(.title2)
                    .bold()
                Divider()
                ForEach(demos) { demo in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(demo.title)
                            .font(.headline)
                        Text(demo.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(demo.code)
                            .font(.system(.body, design: .monospaced))
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(6)
                        Button("执行并输出结果") {
                            output = demo.test()
                        }
                        .padding(.top, 4)
                        if output != "" && output == demo.test() {
                            Text(output)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color(.systemGray5))
                                .cornerRadius(6)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("扩展算法演示 (C语言算法Swift实现)")
        .navigationBarTitleDisplayMode(.inline)
    }
} 