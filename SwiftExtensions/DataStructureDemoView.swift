import SwiftUI

struct DataStructureDemoView: View {
    struct DemoItem: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let code: String
        let test: () -> String
    }
    
    @State private var output: String = ""
    
    let demos: [DemoItem] = [
        DemoItem(
            title: "栈 (Stack)",
            description: "演示如何使用自定义栈结构。",
            code: "var stack = Stack<Int>()\nstack.push(1)\nstack.push(2)\nlet top = stack.pop() // 2",
            test: {
                var stack = Stack<Int>()
                stack.push(1)
                stack.push(2)
                let top = stack.pop() ?? -1
                let afterPop = stack.pop() ?? -1
                return """
操作: push(1), push(2), pop(), pop()
输出: 第一次pop: \(top), 第二次pop: \(afterPop)
"""
            }
        ),
        DemoItem(
            title: "队列 (Queue)",
            description: "演示如何使用自定义队列结构。",
            code: "var queue = Queue<Int>()\nqueue.enqueue(1)\nqueue.enqueue(2)\nlet first = queue.dequeue() // 1",
            test: {
                var queue = Queue<Int>()
                queue.enqueue(1)
                queue.enqueue(2)
                let first = queue.dequeue() ?? -1
                let second = queue.dequeue() ?? -1
                return """
操作: enqueue(1), enqueue(2), dequeue(), dequeue()
输出: 第一次dequeue: \(first), 第二次dequeue: \(second)
"""
            }
        ),
        DemoItem(
            title: "双端队列 (Deque)",
            description: "演示如何使用双端队列结构。",
            code: "var deque = Deque<Int>()\ndeque.append(1)\ndeque.appendLeft(0)\nlet right = deque.pop() // 1\nlet left = deque.popLeft() // 0",
            test: {
                var deque = Deque<Int>()
                deque.append(1)
                deque.appendLeft(0)
                let right = deque.pop() ?? -1
                let left = deque.popLeft() ?? -1
                return """
操作: append(1), appendLeft(0), pop(), popLeft()
输出: pop: \(right), popLeft: \(left)
"""
            }
        ),
        DemoItem(
            title: "最小堆 (MinHeap)",
            description: "演示如何使用最小堆结构。",
            code: "var heap = MinHeap<Int>()\nheap.insert(3)\nheap.insert(1)\nheap.insert(2)\nlet minVal = heap.removeMin() // 1",
            test: {
                var heap = MinHeap<Int>()
                heap.insert(3)
                heap.insert(1)
                heap.insert(2)
                let minVal = heap.removeMin() ?? -1
                return """
操作: insert(3), insert(1), insert(2), removeMin()
输出: removeMin: \(minVal)
"""
            }
        ),
        DemoItem(
            title: "最大堆 (MaxHeap)",
            description: "演示如何使用最大堆结构。",
            code: "var maxHeap = MaxHeap<Int>()\nmaxHeap.insert(3)\nmaxHeap.insert(5)\nmaxHeap.insert(1)\nlet maxVal = maxHeap.removeMax() // 5",
            test: {
                var maxHeap = MaxHeap<Int>()
                maxHeap.insert(3)
                maxHeap.insert(5)
                maxHeap.insert(1)
                let maxVal = maxHeap.removeMax() ?? -1
                return """
操作: insert(3), insert(5), insert(1), removeMax()
输出: removeMax: \(maxVal)
"""
            }
        ),
        DemoItem(
            title: "单向链表 (SinglyLinkedList)",
            description: "演示如何使用自定义单向链表结构。",
            code: "let list = SinglyLinkedList<Int>()\nlist.insertAtTail(1)\nlist.insertAtTail(2)\nlet arr = list.toArray() // [1, 2]",
            test: {
                let list = SinglyLinkedList<Int>()
                list.insertAtTail(1)
                list.insertAtTail(2)
                let arr = list.toArray()
                return """
操作: insertAtTail(1), insertAtTail(2), toArray()
输出: \(arr)
"""
            }
        ),
        DemoItem(
            title: "双向链表 (DoublyLinkedList)",
            description: "演示如何使用双向链表结构。",
            code: "let dlist = DoublyLinkedList<Int>()\ndlist.insertAtHead(2)\ndlist.insertAtTail(3)\ndlist.insertAtHead(1)\nlet arr = dlist.toArray() // [1,2,3]",
            test: {
                let dlist = DoublyLinkedList<Int>()
                dlist.insertAtHead(2)
                dlist.insertAtTail(3)
                dlist.insertAtHead(1)
                let arr = dlist.toArray()
                return """
操作: insertAtHead(2), insertAtTail(3), insertAtHead(1), toArray()
输出: \(arr)
"""
            }
        ),
        DemoItem(
            title: "字典树 (Trie)",
            description: "演示如何使用字典树结构。",
            code: "let trie = Trie()\ntrie.insert(\"apple\")\nlet hasApple = trie.search(\"apple\") // true\nlet hasApp = trie.startsWith(\"app\") // true",
            test: {
                let trie = Trie()
                trie.insert("apple")
                let hasApple = trie.search("apple")
                let hasApp = trie.startsWith("app")
                return """
操作: insert("apple"), search("apple"), startsWith("app")
输出: search: \(hasApple), startsWith: \(hasApp)
"""
            }
        ),
        DemoItem(
            title: "并查集 (UnionFind)",
            description: "演示如何使用并查集结构。",
            code: "let uf = UnionFind(5)\nuf.union(0, 1)\nlet conn = uf.connected(0, 1) // true",
            test: {
                let uf = UnionFind(5)
                uf.union(0, 1)
                let conn = uf.connected(0, 1)
                return """
操作: union(0,1), connected(0,1)
输出: \(conn)
"""
            }
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("数据结构演示")
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
        .navigationTitle("数据结构演示")
        .navigationBarTitleDisplayMode(.inline)
    }
} 