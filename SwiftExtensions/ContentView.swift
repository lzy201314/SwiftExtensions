//
//  ContentView.swift
//  SwiftExtensions
//
//  Created by 陆志勇 on 2025/7/25.
//

import SwiftUI
import WebKit

struct ExtensionFileListView: View {
    @State private var searchText = ""
    @State private var selectedFile: String? = nil
    @State private var showDemo: Bool = false
    @State private var demoType: DemoType? = nil
    
    enum DemoType: String, Identifiable {
        case dataStructure, algorithmStd, algorithmExt
        var id: String { rawValue }
        var title: String {
            switch self {
            case .dataStructure: return "数据结构演示"
            case .algorithmStd: return "标准库算法演示"
            case .algorithmExt: return "扩展算法演示"
            }
        }
    }
    
    let groupedFiles: [String: [String]] = [
        "Foundation": [
            "Array+YYAdd.swift", "Bundle+YYAdd.swift", "Combine+YYAdd.swift", "Data+YYAdd.swift",
            "Date+YYAdd.swift", "Dictionary+YYAdd.swift", "DispatchQueue+YYAdd.swift", "GCDTimer+YYAdd.swift",
            "NSKeyedUnarchiver+YYAdd.swift", "NSNotificationCenter+YYAdd.swift", "NSNumber+YYAdd.swift",
            "NSObject+YYAdd.swift", "NSObject+YYAddForKVO.swift", "NSThread+YYAdd.swift", "String+YYAdd.swift",
            "UserDefaults+YYAdd.swift"
        ],
        "UIKit": [
            "UIBarButtonItem+YYAdd.swift", "UIBezierPath+YYAdd.swift", "UIButton+Closure.swift", "UIButton+Debounce.swift",
            "UIButton+LayoutExtension.swift", "UIColor+YYAdd.swift", "UIControl+YYAdd.swift", "UIDevice+YYAdd.swift",
            "UIFont+DebugExtension.swift", "UIFont+YYAdd.swift", "UIGestureRecognizer+YYAdd.swift", "UIImage+YYAdd.swift",
            "UILabel+AttributedText.swift", "UILabel+Debounce.swift", "UIScreen+YYAdd.swift", "UIScrollView+YYAdd.swift",
            "UITableView+YYAdd.swift", "UITextField+YYAdd.swift", "UIView+Animation.swift", "UIView+CornerShadow.swift",
            "UIView+Extension.swift", "UIView+YYAdd.swift", "UIView+YYGesture.swift", "UIViewController+Extension.swift",
            "UIViewController+NavigationExtension.swift"
        ],
        "Other": [
            "Algorithm+YYAdd.swift", "DataStructure+YYAdd.swift", "UIApplication+YYAdd.swift"
        ]
    ]
    
    var filteredGroupedFiles: [String: [String]] {
        if searchText.isEmpty {
            return groupedFiles
        } else {
            var result: [String: [String]] = [:]
            for (group, files) in groupedFiles {
                let filtered = files.filter { $0.localizedCaseInsensitiveContains(searchText) }
                if !filtered.isEmpty {
                    result[group] = filtered
                }
            }
            return result
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // 新增：演示分组
                Section(header: Text("算法与数据结构演示")) {
                    Button {
                        demoType = .dataStructure
                        showDemo = true
                    } label: {
                        Text("如何使用数据结构")
                    }
                    Button {
                        demoType = .algorithmStd
                        showDemo = true
                    } label: {
                        Text("标准库算法演示")
                    }
                    Button {
                        demoType = .algorithmExt
                        showDemo = true
                    } label: {
                        Text("扩展算法演示 (C语言算法Swift实现)")
                    }
                }
                ForEach(filteredGroupedFiles.keys.sorted(), id: \.self) { group in
                    Section(header: Text(group)) {
                        ForEach(filteredGroupedFiles[group]!, id: \.self) { file in
                            NavigationLink(destination: FileDetailView(fileName: file), tag: file, selection: $selectedFile) {
                                Text(file)
                            }
                        }
                    }
                }
            }
            .navigationTitle("扩展文件列表")
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "搜索文件名")
            .background(
                NavigationLink(
                    destination:
                        demoType == .algorithmStd ? AnyView(AlgorithmDemoView()) :
                        demoType == .algorithmExt ? AnyView(ExtensionAlgorithmDemoView()) :
                        AnyView(DataStructureDemoView()),
                    isActive: $showDemo,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
}

struct FileDetailView: View {
    let fileName: String
    @State private var functionNames: [String] = []
    @State private var isLoading = true
    @State private var searchText = ""
    @State private var fileContent: String = ""
    @State private var selectedFunction: String? = nil
    
    var filteredFunctionNames: [String] {
        if searchText.isEmpty {
            return functionNames
        } else {
            return functionNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(fileName)
                .font(.title2)
                .padding(.top)
            if isLoading {
                ProgressView("正在加载函数名...")
                    .padding()
            } else if functionNames.isEmpty {
                Text("未找到函数名").foregroundColor(.secondary)
            } else {
                List(filteredFunctionNames, id: \.self) { name in
                    NavigationLink(destination: FunctionDetailView(functionName: name, fileContent: fileContent)) {
                        Text(name)
                            .font(.system(.body, design: .monospaced))
                    }
                }
                .searchable(text: $searchText, placement: .automatic, prompt: "搜索函数名")
            }
            Spacer()
        }
        .padding()
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadFunctionNames()
        }
    }
    
    func loadFunctionNames() {
        isLoading = true
        functionNames = []
        fileContent = ""
        let searchDirs = ["Foundation", "UIKit", "Other"]
        var found = false
        let baseAbs = "/Users/luzhiyong/luzhiyongGitHub/SwiftExtensions/SwiftExtensions/Extensions"
        for dir in searchDirs {
            let absPath = "\(baseAbs)/\(dir)/\(fileName)"
            if FileManager.default.fileExists(atPath: absPath) {
                if let content = try? String(contentsOfFile: absPath) {
                    self.functionNames = extractFunctionNames(from: content)
                    self.fileContent = content
                    found = true
                    break
                }
            }
        }
        if !found {
            for dir in searchDirs {
                let resourceName = fileName.replacingOccurrences(of: ".swift", with: "")
                if let url = Bundle.main.url(forResource: resourceName, withExtension: "swift", subdirectory: "Extensions/\(dir)") {
                    if let content = try? String(contentsOf: url) {
                        self.functionNames = extractFunctionNames(from: content)
                        self.fileContent = content
                        found = true
                        break
                    }
                }
            }
        }
        isLoading = false
        if !found {
            self.functionNames = []
            self.fileContent = ""
        }
    }
    
    func extractFunctionNames(from content: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: "(func|var|static func|class func)\\s+([a-zA-Z0-9_]+)", options: [])
        let nsrange = NSRange(content.startIndex..<content.endIndex, in: content)
        let matches = regex.matches(in: content, options: [], range: nsrange)
        let names = matches.compactMap { match -> String? in
            guard match.numberOfRanges >= 3 else { return nil }
            let typeRange = match.range(at: 1)
            let nameRange = match.range(at: 2)
            if let type = Range(typeRange, in: content), let name = Range(nameRange, in: content) {
                return "\(content[type]) \(content[name])"
            }
            return nil
        }
        return names
    }
}

struct FunctionDetailWebView: UIViewRepresentable {
    let code: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.systemGray6
        webView.scrollView.backgroundColor = UIColor.systemGray6
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/github.min.css'>
        <script src='https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js'></script>
        <script>hljs.highlightAll();</script>
        <style>
        body { background: #f2f2f7; font-family: Menlo, monospace; margin: 0; }
        pre { font-size: 15px; margin: 0; }
        </style>
        </head>
        <body>
        <pre><code class='swift'>\(code.replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;").replacingOccurrences(of: "&", with: "&amp;").replacingOccurrences(of: "\"", with: "&quot;"))</code></pre>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}

struct FunctionDetailView: View {
    let functionName: String
    let fileContent: String

    struct FunctionSignature {
        let name: String
        let parameters: String
        let returnType: String
    }

    var signature: FunctionSignature? {
        let funcName = functionName.split(separator: " ").last ?? ""
        // 匹配 func/var/static/class + 任意修饰符 + 函数名 + 参数 + 返回值
        let pattern = "(func|var|static func|class func)[^\\n\\{]*\\b\(funcName)\\b\\s*(\\([^)]*\\))?\\s*(->\\s*[^\\s\\{]+)?"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsrange = NSRange(fileContent.startIndex..<fileContent.endIndex, in: fileContent)
            if let match = regex.firstMatch(in: fileContent, options: [], range: nsrange) {
                let name = String(funcName)
                var params = ""
                var ret = ""
                if match.numberOfRanges > 2, let pr = Range(match.range(at: 2), in: fileContent) {
                    params = String(fileContent[pr])
                }
                if match.numberOfRanges > 3, let rr = Range(match.range(at: 3), in: fileContent) {
                    ret = String(fileContent[rr]).replacingOccurrences(of: "->", with: "").trimmingCharacters(in: .whitespaces)
                }
                return FunctionSignature(name: name, parameters: params, returnType: ret)
            }
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(functionName)
                .font(.title3)
                .bold()
            Divider()
            if let sig = signature {
                HStack {
                    Text("函数名：").bold()
                    Text(sig.name)
                        .font(.system(.body, design: .monospaced))
                }
                HStack {
                    Text("参数：").bold()
                    Text(sig.parameters.isEmpty ? "无" : sig.parameters)
                        .font(.system(.body, design: .monospaced))
                }
                HStack {
                    Text("返回值：").bold()
                    Text(sig.returnType.isEmpty ? "无" : sig.returnType)
                        .font(.system(.body, design: .monospaced))
                }
                Divider()
                Text("{")
                    .font(.system(.body, design: .monospaced))
                Text(functionComment ?? "// body 占位")
                    .foregroundColor(.secondary)
                    .italic()
                    .font(.system(.body, design: .monospaced))
                    .padding(.leading, 16)
                Text("}")
                    .font(.system(.body, design: .monospaced))
            } else {
                Text("未能解析函数签名")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("函数详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    // 新增：提取函数签名上方注释
    var functionComment: String? {
        let funcName = functionName.split(separator: " ").last ?? ""
        let pattern = #"(//.*|/\*[\s\S]*?\*/)?\s*(func|var|static func|class func)[^\n\{]*\b"# + funcName + #"\b"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsrange = NSRange(fileContent.startIndex..<fileContent.endIndex, in: fileContent)
            if let match = regex.firstMatch(in: fileContent, options: [], range: nsrange) {
                if match.numberOfRanges > 1, let commentRange = Range(match.range(at: 1), in: fileContent) {
                    let comment = String(fileContent[commentRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !comment.isEmpty { return comment }
                }
            }
        } catch {
            // 正则错误兜底
            return nil
        }
        return nil
    }
}

struct DemoView: View {
    let type: ExtensionFileListView.DemoType
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(type.title)
                .font(.title2)
                .bold()
            Divider()
            if type == .dataStructure {
                Text("// 这里演示如何使用 DataStructure+YYAdd.swift 里的数据结构扩展\n\n例如：\nlet stack = Stack<Int>()\nstack.push(1)\n...")
                    .font(.system(.body, design: .monospaced))
            } else {
                Text("// 这里演示如何使用 Algorithm+YYAdd.swift 里的算法扩展\n\n例如：\nlet sorted = [3,1,2].bubbleSorted()\n...")
                    .font(.system(.body, design: .monospaced))
            }
            Spacer()
        }
        .padding()
        .navigationTitle("演示")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView: View {
    var body: some View {
        ExtensionFileListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    ContentView()
    }
}
