//
//  DataStructure+YYAdd.swift
//  tongshengbao_cn
//  Moved to: Common/Extensions/Other/DataStructure+YYAdd.swift
//
//  Created by AI on 2024/06/09. 常用数据结构扩展。
//

import Foundation

// MARK: - 栈（Stack）
/// 栈：后进先出（LIFO）
public struct Stack<Element> {
    private var elements: [Element] = []
    public init() {}
    /// 是否为空
    public var isEmpty: Bool { elements.isEmpty }
    /// 元素个数
    public var count: Int { elements.count }
    /// 入栈
    public mutating func push(_ value: Element) { elements.append(value) }
    /// 出栈
    public mutating func pop() -> Element? { elements.popLast() }
    /// 查看栈顶元素
    public func peek() -> Element? { elements.last }
}

// MARK: - 队列（Queue）
/// 队列：先进先出（FIFO）
public struct Queue<Element> {
    private var elements: [Element] = []
    public init() {}
    /// 是否为空
    public var isEmpty: Bool { elements.isEmpty }
    /// 元素个数
    public var count: Int { elements.count }
    /// 入队
    public mutating func enqueue(_ value: Element) { elements.append(value) }
    /// 出队
    public mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
    /// 查看队头元素
    public func peek() -> Element? { elements.first }
}

// MARK: - 双端队列（Deque）
/// 双端队列：两端都可进出
public struct Deque<Element> {
    private var elements: [Element] = []
    public init() {}
    /// 是否为空
    public var isEmpty: Bool { elements.isEmpty }
    /// 元素个数
    public var count: Int { elements.count }
    /// 右端入队
    public mutating func append(_ value: Element) { elements.append(value) }
    /// 左端入队
    public mutating func appendLeft(_ value: Element) { elements.insert(value, at: 0) }
    /// 右端出队
    public mutating func pop() -> Element? { elements.popLast() }
    /// 左端出队
    public mutating func popLeft() -> Element? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
    /// 查看右端元素
    public func peek() -> Element? { elements.last }
    /// 查看左端元素
    public func peekLeft() -> Element? { elements.first }
}

// MARK: - 最小堆（MinHeap，优先队列）
/// 最小堆：每次取出最小元素
public struct MinHeap<Element: Comparable> {
    private var elements: [Element] = []
    public init() {}
    /// 是否为空
    public var isEmpty: Bool { elements.isEmpty }
    /// 元素个数
    public var count: Int { elements.count }
    /// 查看最小元素
    public func peek() -> Element? { elements.first }
    /// 插入元素
    public mutating func insert(_ value: Element) {
        elements.append(value)
        siftUp(elements.count - 1)
    }
    /// 移除最小元素
    public mutating func removeMin() -> Element? {
        guard !elements.isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1)
        let min = elements.removeLast()
        siftDown(0)
        return min
    }
    private mutating func siftUp(_ index: Int) {
        var child = index
        var parent = (child - 1) / 2
        while child > 0 && elements[child] < elements[parent] {
            elements.swapAt(child, parent)
            child = parent
            parent = (child - 1) / 2
        }
    }
    private mutating func siftDown(_ index: Int) {
        var parent = index
        while true {
            let left = 2 * parent + 1
            let right = 2 * parent + 2
            var candidate = parent
            if left < elements.count && elements[left] < elements[candidate] {
                candidate = left
            }
            if right < elements.count && elements[right] < elements[candidate] {
                candidate = right
            }
            if candidate == parent { break }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

// MARK: - 单向链表（SinglyLinkedList）
/// 单向链表，支持头插、尾插、查找、删除
public class SinglyLinkedListNode<Element> {
    public var value: Element
    public var next: SinglyLinkedListNode?
    public init(_ value: Element) { self.value = value }
}

public class SinglyLinkedList<Element: Equatable> {
    public private(set) var head: SinglyLinkedListNode<Element>?
    public init() {}
    /// 头插法
    public func insertAtHead(_ value: Element) {
        let node = SinglyLinkedListNode(value)
        node.next = head
        head = node
    }
    /// 尾插法
    public func insertAtTail(_ value: Element) {
        let node = SinglyLinkedListNode(value)
        if head == nil {
            head = node
            return
        }
        var cur = head
        while cur?.next != nil { cur = cur?.next }
        cur?.next = node
    }
    /// 查找节点
    public func find(_ value: Element) -> SinglyLinkedListNode<Element>? {
        var cur = head
        while let node = cur {
            if node.value == value { return node }
            cur = node.next
        }
        return nil
    }
    /// 删除节点
    public func delete(_ value: Element) {
        var cur = head
        var prev: SinglyLinkedListNode<Element>? = nil
        while let node = cur {
            if node.value == value {
                if prev == nil {
                    head = node.next
                } else {
                    prev?.next = node.next
                }
                return
            }
            prev = cur
            cur = node.next
        }
    }
    /// 转数组
    public func toArray() -> [Element] {
        var arr: [Element] = []
        var cur = head
        while let node = cur {
            arr.append(node.value)
            cur = node.next
        }
        return arr
    }
}

// MARK: - 字典树（Trie）
/// 字典树/前缀树，适合前缀匹配、自动补全
public class TrieNode {
    public var children: [Character: TrieNode] = [:]
    public var isEnd: Bool = false
    public init() {}
}

public class Trie {
    private let root = TrieNode()
    public init() {}
    /// 插入单词
    public func insert(_ word: String) {
        var node = root
        for char in word {
            if node.children[char] == nil {
                node.children[char] = TrieNode()
            }
            node = node.children[char]!
        }
        node.isEnd = true
    }
    /// 查找单词是否存在
    public func search(_ word: String) -> Bool {
        var node = root
        for char in word {
            guard let next = node.children[char] else { return false }
            node = next
        }
        return node.isEnd
    }
    /// 是否有以 prefix 为前缀的单词
    public func startsWith(_ prefix: String) -> Bool {
        var node = root
        for char in prefix {
            guard let next = node.children[char] else { return false }
            node = next
        }
        return true
    }
}

// MARK: - 并查集（UnionFind/DisjointSet）
/// 并查集，支持合并、查找、连通性判定
public class UnionFind {
    private var parent: [Int]
    public init(_ n: Int) {
        parent = Array(0..<n)
    }
    /// 查找根节点
    public func find(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = find(parent[x]) // 路径压缩
        }
        return parent[x]
    }
    /// 合并两个集合
    public func union(_ x: Int, _ y: Int) {
        let rootX = find(x)
        let rootY = find(y)
        if rootX != rootY {
            parent[rootX] = rootY
        }
    }
    /// 判断是否连通
    public func connected(_ x: Int, _ y: Int) -> Bool {
        return find(x) == find(y)
    }
}

// MARK: - 最大堆（MaxHeap，优先队列）
/// 最大堆：每次取出最大元素
public struct MaxHeap<Element: Comparable> {
    private var elements: [Element] = []
    public init() {}
    /// 是否为空
    public var isEmpty: Bool { elements.isEmpty }
    /// 元素个数
    public var count: Int { elements.count }
    /// 查看最大元素
    public func peek() -> Element? { elements.first }
    /// 插入元素
    public mutating func insert(_ value: Element) {
        elements.append(value)
        siftUp(elements.count - 1)
    }
    /// 移除最大元素
    public mutating func removeMax() -> Element? {
        guard !elements.isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1)
        let max = elements.removeLast()
        siftDown(0)
        return max
    }
    private mutating func siftUp(_ index: Int) {
        var child = index
        var parent = (child - 1) / 2
        while child > 0 && elements[child] > elements[parent] {
            elements.swapAt(child, parent)
            child = parent
            parent = (child - 1) / 2
        }
    }
    private mutating func siftDown(_ index: Int) {
        var parent = index
        while true {
            let left = 2 * parent + 1
            let right = 2 * parent + 2
            var candidate = parent
            if left < elements.count && elements[left] > elements[candidate] {
                candidate = left
            }
            if right < elements.count && elements[right] > elements[candidate] {
                candidate = right
            }
            if candidate == parent { break }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

// MARK: - 双向链表（DoublyLinkedList）
/// 双向链表，支持头尾插入、查找、删除
public class DoublyLinkedListNode<Element> {
    public var value: Element
    public var prev: DoublyLinkedListNode?
    public var next: DoublyLinkedListNode?
    public init(_ value: Element) { self.value = value }
}

public class DoublyLinkedList<Element: Equatable> {
    public private(set) var head: DoublyLinkedListNode<Element>?
    public private(set) var tail: DoublyLinkedListNode<Element>?
    public init() {}
    /// 头插法
    public func insertAtHead(_ value: Element) {
        let node = DoublyLinkedListNode(value)
        node.next = head
        head?.prev = node
        head = node
        if tail == nil { tail = node }
    }
    /// 尾插法
    public func insertAtTail(_ value: Element) {
        let node = DoublyLinkedListNode(value)
        node.prev = tail
        tail?.next = node
        tail = node
        if head == nil { head = node }
    }
    /// 在指定节点后插入新节点
    public func insert(_ value: Element, after node: DoublyLinkedListNode<Element>) {
        let newNode = DoublyLinkedListNode(value)
        newNode.prev = node
        newNode.next = node.next
        node.next?.prev = newNode
        node.next = newNode
        if tail === node { tail = newNode }
    }
    /// 查找节点
    public func find(_ value: Element) -> DoublyLinkedListNode<Element>? {
        var cur = head
        while let node = cur {
            if node.value == value { return node }
            cur = node.next
        }
        return nil
    }
    /// 删除节点（只删第一个匹配）
    public func delete(_ value: Element) {
        var cur = head
        while let node = cur {
            if node.value == value {
                delete(node)
                return
            }
            cur = node.next
        }
    }
    /// 删除指定节点（节点对象）
    public func delete(_ node: DoublyLinkedListNode<Element>) {
        if node.prev == nil {
            head = node.next
        } else {
            node.prev?.next = node.next
        }
        if node.next == nil {
            tail = node.prev
        } else {
            node.next?.prev = node.prev
        }
        node.prev = nil
        node.next = nil
    }
    /// 正向转数组
    public func toArray() -> [Element] {
        var arr: [Element] = []
        var cur = head
        while let node = cur {
            arr.append(node.value)
            cur = node.next
        }
        return arr
    }
    /// 反向转数组
    public func toReversedArray() -> [Element] {
        var arr: [Element] = []
        var cur = tail
        while let node = cur {
            arr.append(node.value)
            cur = node.prev
        }
        return arr
    }
}

/*
// ===================
// 常用数据结构扩展用法示例
// ===================

// 栈
var stack = Stack<Int>()
stack.push(1)
stack.push(2)
let top = stack.pop() // 2

// 队列
var queue = Queue<String>()
queue.enqueue("a")
queue.enqueue("b")
let first = queue.dequeue() // "a"

// 双端队列
var deque = Deque<Int>()
deque.append(1)
deque.appendLeft(0)
let right = deque.pop() // 1
let left = deque.popLeft() // 0

// 最小堆
var heap = MinHeap<Int>()
heap.insert(3)
heap.insert(1)
heap.insert(2)
let minVal = heap.removeMin() // 1

// 单向链表
let list = SinglyLinkedList<Int>()
list.insertAtHead(2)
list.insertAtTail(3)
list.insertAtHead(1)
let arr = list.toArray() // [1,2,3]
list.delete(2)
let found = list.find(3) // 节点或 nil

// 字典树
let trie = Trie()
trie.insert("apple")
let hasApple = trie.search("apple") // true
let hasApp = trie.startsWith("app") // true

// 并查集
let uf = UnionFind(5)
uf.union(0, 1)
let conn = uf.connected(0, 1) // true

// 最大堆
var maxHeap = MaxHeap<Int>()
maxHeap.insert(3)
maxHeap.insert(5)
maxHeap.insert(1)
let maxVal = maxHeap.removeMax() // 5

// 双向链表
let dlist = DoublyLinkedList<Int>()
dlist.insertAtHead(2)
dlist.insertAtTail(3)
dlist.insertAtHead(1)
let darr = dlist.toArray() // [1,2,3]
dlist.delete(2)
let dfound = dlist.find(3) // 节点或 nil
// 在指定节点后插入
if let node1 = dlist.find(1) {
    dlist.insert(5, after: node1)
}
// 删除指定节点
if let node3 = dlist.find(3) {
    dlist.delete(node3)
}
let reversed = dlist.toReversedArray() // 反向遍历转数组
*/ 