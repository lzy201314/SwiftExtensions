import SwiftUI

struct AlgorithmDemoView: View {
    struct DemoItem: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let code: String
        let test: () -> String
    }
    
    @State private var output: String = ""
    
    let demos: [DemoItem]
    
    init() {
        self.demos = [
            DemoItem(
                title: "冒泡排序 (bubbleSorted)",
                description: "对数组进行冒泡排序，返回排序后的新数组。",
                code: "let arr = [3, 1, 2]\nlet sorted = arr.bubbleSorted() // [1, 2, 3]",
                test: {
                    let arr = [3, 1, 2]
                    let sorted = arr.sorted() // 用标准库模拟
                    return "输入: [3, 1, 2]\n输出: \(sorted)"
                }
            ),
            DemoItem(
                title: "快速排序 (quickSorted)",
                description: "对数组进行快速排序，返回排序后的新数组。",
                code: "let arr = [5, 2, 8, 1]\nlet sorted = arr.quickSorted() // [1, 2, 5, 8]",
                test: {
                    let arr = [5, 2, 8, 1]
                    let sorted = arr.sorted()
                    return "输入: [5, 2, 8, 1]\n输出: \(sorted)"
                }
            ),
            DemoItem(
                title: "二分查找 (binarySearch)",
                description: "在有序数组中查找目标元素，返回索引或 nil。",
                code: "let arr = [1, 2, 3, 4, 5]\nlet index = arr.binarySearch(3) // 2",
                test: {
                    let arr = [1, 2, 3, 4, 5]
                    let index = arr.firstIndex(of: 3)
                    return "输入: [1, 2, 3, 4, 5], 查找: 3\n输出: \(index ?? -1)"
                }
            ),
            DemoItem(
                title: "插入排序 (insertionSorted)",
                description: "对数组进行插入排序，返回排序后的新数组。",
                code: "let arr = [4, 2, 7, 1]\nlet sorted = arr.insertionSorted() // [1, 2, 4, 7]",
                test: {
                    let arr = [4, 2, 7, 1]
                    let sorted = arr.sorted()
                    return "输入: [4, 2, 7, 1]\n输出: \(sorted)"
                }
            ),
            DemoItem(
                title: "选择排序 (selectionSorted)",
                description: "对数组进行选择排序，返回排序后的新数组。",
                code: "let arr = [9, 3, 6, 2]\nlet sorted = arr.selectionSorted() // [2, 3, 6, 9]",
                test: {
                    let arr = [9, 3, 6, 2]
                    let sorted = arr.sorted()
                    return "输入: [9, 3, 6, 2]\n输出: \(sorted)"
                }
            ),
            DemoItem(
                title: "线性查找 (linearSearch)",
                description: "在数组中查找目标元素，返回索引或 nil。",
                code: "let arr = [10, 20, 30]\nlet index = arr.linearSearch(20) // 1",
                test: {
                    let arr = [10, 20, 30]
                    let index = arr.firstIndex(of: 20)
                    return "输入: [10, 20, 30], 查找: 20\n输出: \(index ?? -1)"
                }
            ),
            DemoItem(
                title: "去重 (unique)",
                description: "返回去重后的新数组。",
                code: "let arr = [1, 2, 2, 3]\nlet uniqueArr = arr.unique() // [1, 2, 3]",
                test: {
                    let arr = [1, 2, 2, 3]
                    let uniqueArr = Array(Set(arr)).sorted()
                    return "输入: [1, 2, 2, 3]\n输出: \(uniqueArr)"
                }
            ),
            DemoItem(
                title: "全排列 (permutations)",
                description: "返回数组的所有排列组合。",
                code: "let arr = [1, 2, 3]\nlet perms = arr.permutations() // [[1,2,3],[1,3,2],...]",
                test: {
                    let arr = [1, 2, 3]
                    func permute(_ nums: [Int]) -> [[Int]] {
                        var res: [[Int]] = []
                        var nums = nums
                        func backtrack(_ start: Int) {
                            if start == nums.count {
                                res.append(nums)
                                return
                            }
                            for i in start..<nums.count {
                                nums.swapAt(i, start)
                                backtrack(start + 1)
                                nums.swapAt(i, start)
                            }
                        }
                        backtrack(0)
                        return res
                    }
                    let perms = permute(arr)
                    return "输入: [1, 2, 3]\n输出: \(perms.prefix(3))... 共\(perms.count)种"
                }
            )
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("算法演示")
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
        .navigationTitle("标准库算法演示")
        .navigationBarTitleDisplayMode(.inline)
    }
} 