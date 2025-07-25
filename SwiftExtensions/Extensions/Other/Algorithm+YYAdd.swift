//
//  Algorithm+YYAdd.swift
//  tongshengbao_cn
//  Moved to: Common/Extensions/Other/Algorithm+YYAdd.swift
//
//  Created by AI on 2024/06/09. 常用算法扩展。
//

import Foundation

// MARK: - Array 常用算法扩展
public extension Array where Element: Comparable {
    /// 冒泡排序，返回排序后的新数组
    /// 用法：let sorted = arr.bubbleSorted()
    /// 时间复杂度: O(n^2)  空间复杂度: O(1)
    func bubbleSorted() -> [Element] {
        var arr = self
        for i in 0..<arr.count {
            for j in 1..<arr.count - i {
                if arr[j-1] > arr[j] {
                    arr.swapAt(j-1, j)
                }
            }
        }
        return arr
    }
    /// 快速排序，返回排序后的新数组
    /// 用法：let sorted = arr.quickSorted()
    /// 时间复杂度: O(nlogn)  空间复杂度: O(logn)
    func quickSorted() -> [Element] {
        guard count > 1 else { return self }
        let pivot = self[count/2]
        let less = filter { $0 < pivot }
        let equal = filter { $0 == pivot }
        let greater = filter { $0 > pivot }
        return less.quickSorted() + equal + greater.quickSorted()
    }
    /// 二分查找（有序数组），返回目标元素下标或 nil
    /// 用法：let idx = arr.binarySearch(5)
    /// 时间复杂度: O(logn)  空间复杂度: O(1)
    func binarySearch(_ target: Element) -> Int? {
        var left = 0, right = count - 1
        while left <= right {
            let mid = left + (right - left) / 2
            if self[mid] == target {
                return mid
            } else if self[mid] < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return nil
    }
    /// 插入排序，返回排序后的新数组
    /// 用法：let sorted = arr.insertionSorted()
    /// 时间复杂度: O(n^2)  空间复杂度: O(1)
    func insertionSorted() -> [Element] {
        var arr = self
        for i in 1..<arr.count {
            var j = i
            let temp = arr[j]
            while j > 0 && arr[j-1] > temp {
                arr[j] = arr[j-1]
                j -= 1
            }
            arr[j] = temp
        }
        return arr
    }
    /// 选择排序，返回排序后的新数组
    /// 用法：let sorted = arr.selectionSorted()
    /// 时间复杂度: O(n^2)  空间复杂度: O(1)
    func selectionSorted() -> [Element] {
        var arr = self
        for i in 0..<arr.count {
            var minIdx = i
            for j in i+1..<arr.count {
                if arr[j] < arr[minIdx] {
                    minIdx = j
                }
            }
            if i != minIdx {
                arr.swapAt(i, minIdx)
            }
        }
        return arr
    }
    /// 线性查找，返回目标元素下标或 nil
    /// 用法：let idx = arr.linearSearch(5)
    /// 时间复杂度: O(n)  空间复杂度: O(1)
    func linearSearch(_ target: Element) -> Int? {
        for (i, v) in self.enumerated() {
            if v == target { return i }
        }
        return nil
    }
    /// 数组去重，返回新数组
    /// 用法：let uniqueArr = arr.unique()
    /// 时间复杂度: O(n)  空间复杂度: O(n)
    func unique() -> [Element] where Element: Hashable {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    /// 全排列，返回所有排列结果
    /// 用法：let perms = arr.permutations()
    /// 时间复杂度: O(n!)  空间复杂度: O(n!)
    func permutations() -> [[Element]] {
        var result: [[Element]] = []
        var arr = self
        func backtrack(_ start: Int) {
            if start == arr.count {
                result.append(arr)
                return
            }
            for i in start..<arr.count {
                arr.swapAt(i, start)
                backtrack(start + 1)
                arr.swapAt(i, start)
            }
        }
        backtrack(0)
        return result
    }
    /// 归并排序，返回排序后的新数组
    /// 用法：let sorted = arr.mergeSorted()
    /// 时间复杂度: O(nlogn)  空间复杂度: O(n)
    func mergeSorted() -> [Element] {
        guard count > 1 else { return self }
        let mid = count / 2
        let left = Array(self[0..<mid]).mergeSorted()
        let right = Array(self[mid..<count]).mergeSorted()
        var merged: [Element] = []
        var i = 0, j = 0
        while i < left.count && j < right.count {
            if left[i] < right[j] {
                merged.append(left[i]); i += 1
            } else {
                merged.append(right[j]); j += 1
            }
        }
        while i < left.count { merged.append(left[i]); i += 1 }
        while j < right.count { merged.append(right[j]); j += 1 }
        return merged
    }
    /// 子集生成，返回所有子集
    /// 用法：let subs = arr.subsets()
    /// 时间复杂度: O(n*2^n)  空间复杂度: O(2^n)
    func subsets() -> [[Element]] {
        var result: [[Element]] = [[]]
        for num in self {
            for subset in result {
                result.append(subset + [num])
            }
        }
        return result
    }
}

// MARK: - String 常用算法扩展
public extension String {
    /// 判断字符串是否为回文
    /// 用法：let isPalin = str.isPalindrome
    /// 时间复杂度: O(n)  空间复杂度: O(n)
    var isPalindrome: Bool {
        let chars = Array(self)
        var left = 0, right = chars.count - 1
        while left < right {
            if chars[left] != chars[right] { return false }
            left += 1
            right -= 1
        }
        return true
    }
    /// 统计某个字符出现次数
    /// 用法：let count = str.count(of: "a")
    /// 时间复杂度: O(n)  空间复杂度: O(1)
    func count(of char: Character) -> Int {
        return self.filter { $0 == char }.count
    }
    /// 字符串反转
    /// 用法：let rev = str.reversedString
    /// 时间复杂度: O(n)  空间复杂度: O(n)
    var reversedString: String { String(self.reversed()) }
    /// 最长公共前缀
    /// 用法：let prefix = String.longestCommonPrefix(["flower","flow","flight"])
    /// 时间复杂度: O(mn)  空间复杂度: O(1)  (m为字符串数量, n为最短字符串长度)
    static func longestCommonPrefix(_ strs: [String]) -> String {
        guard let first = strs.first else { return "" }
        var prefix = first
        for str in strs.dropFirst() {
            while !str.hasPrefix(prefix) {
                prefix = String(prefix.dropLast())
                if prefix.isEmpty { return "" }
            }
        }
        return prefix
    }
    /// KMP字符串查找，返回 pattern 在 self 中首次出现的位置，无则为 -1
    /// 用法：let idx = str.kmpSearch("abc")
    /// 时间复杂度: O(n+m)  空间复杂度: O(m)  (n为主串长度, m为模式串长度)
    func kmpSearch(_ pattern: String) -> Int {
        let s = Array(self), p = Array(pattern)
        let n = s.count, m = p.count
        if m == 0 { return 0 }
        var lps = [Int](repeating: 0, count: m)
        // 预处理lps数组
        var len = 0, i = 1
        while i < m {
            if p[i] == p[len] {
                len += 1; lps[i] = len; i += 1
            } else if len != 0 {
                len = lps[len-1]
            } else {
                lps[i] = 0; i += 1
            }
        }
        // KMP主过程
        i = 0; var j = 0
        while i < n {
            if s[i] == p[j] {
                i += 1; j += 1
            }
            if j == m { return i - j }
            else if i < n && s[i] != p[j] {
                if j != 0 { j = lps[j-1] }
                else { i += 1 }
            }
        }
        return -1
    }
}

// MARK: - Int 常用算法扩展
public extension Int {
    /// 判断整数是否为质数
    /// 用法：let isPrime = 17.isPrime
    /// 时间复杂度: O(√n)  空间复杂度: O(1)
    var isPrime: Bool {
        if self < 2 { return false }
        for i in 2...Int(Double(self).squareRoot()) {
            if self % i == 0 { return false }
        }
        return true
    }
    /// 计算阶乘
    /// 用法：let fact = 5.factorial
    /// 时间复杂度: O(n)  空间复杂度: O(1)
    var factorial: Int {
        return (1...Swift.max(1, self)).reduce(1, *)
    }
    /// 判断整数是否为回文数
    /// 用法：let isPalNum = 121.isPalindromeNumber
    /// 时间复杂度: O(d)  空间复杂度: O(d)  (d为数字位数)
    var isPalindromeNumber: Bool {
        let s = String(self)
        return s == String(s.reversed())
    }
}

// MARK: - 通用算法工具
public struct AlgorithmUtils {
    /// 斐波那契数列（递归）
    /// 用法：let fib = AlgorithmUtils.fibonacci(10)
    /// 时间复杂度: O(2^n)  空间复杂度: O(n)
    public static func fibonacci(_ n: Int) -> Int {
        if n <= 1 { return n }
        return fibonacci(n-1) + fibonacci(n-2)
    }
    /// 最大公约数
    /// 用法：let g = AlgorithmUtils.gcd(24, 36)
    /// 时间复杂度: O(log(min(a,b)))  空间复杂度: O(1)
    public static func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 {
            let t = b
            b = a % b
            a = t
        }
        return a
    }
    /// 最小公倍数
    /// 用法：let l = AlgorithmUtils.lcm(6, 8)
    /// 时间复杂度: O(log(min(a,b)))  空间复杂度: O(1)
    public static func lcm(_ a: Int, _ b: Int) -> Int {
        return a * b / gcd(a, b)
    }
    /// 快速幂（支持大数取模）
    /// 用法：let pow = AlgorithmUtils.fastPower(2, 10, 1000)
    /// 时间复杂度: O(logn)  空间复杂度: O(1)
    public static func fastPower(_ base: Int, _ exp: Int, _ mod: Int) -> Int {
        var res = 1, b = base % mod, e = exp
        while e > 0 {
            if e & 1 == 1 { res = res * b % mod }
            b = b * b % mod
            e >>= 1
        }
        return res
    }
}

/*
// ===================
// 常用算法扩展用法示例（全覆盖）
// ===================

// Array 排序与查找
let arr = [3, 1, 4, 1, 5, 9]
let sorted1 = arr.bubbleSorted()         // 冒泡排序
let sorted2 = arr.quickSorted()          // 快速排序
let sorted3 = arr.insertionSorted()      // 插入排序
let sorted4 = arr.selectionSorted()      // 选择排序
let sorted5 = arr.mergeSorted()          // 归并排序
let idx = sorted2.binarySearch(4)        // 二分查找
let idx2 = arr.linearSearch(4)           // 线性查找
let uniqueArr = arr.unique()             // 数组去重
let perms = arr.permutations()           // 全排列
let subs = arr.subsets()                 // 子集生成

// String
let str = "level"
let isPalin = str.isPalindrome           // 回文判断
let aCount = str.count(of: "e")         // 字符出现次数
let rev = str.reversedString             // 字符串反转
let prefix = String.longestCommonPrefix(["flower","flow","flight"]) // 最长公共前缀
let idxKMP = str.kmpSearch("el")        // KMP字符串查找

// Int
let isPrime = 17.isPrime                 // 质数判断
let fact = 5.factorial                   // 阶乘
let isPalNum = 121.isPalindromeNumber    // 判断回文数

// 通用算法工具
let fib = AlgorithmUtils.fibonacci(10)   // 斐波那契数列第10项
let g = AlgorithmUtils.gcd(24, 36)       // 最大公约数
let l = AlgorithmUtils.lcm(6, 8)         // 最小公倍数
let pow = AlgorithmUtils.fastPower(2, 10, 1000) // 快速幂
*/ 