//
//  UIApplication+YYAdd.swift
//  tongshengbao_cn
//
//  Created by migration from YYKit's UIApplication+YYAdd.
//

import UIKit
import ObjectiveC
import MachO
import Darwin

extension UIApplication {
    // MARK: - 沙盒路径
    var documentsURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    var documentsPath: String? {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    var cachesURL: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    var cachesPath: String? {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    var libraryURL: URL? {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    var libraryPath: String? {
        NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }
    // MARK: - App 信息
    var appBundleName: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    var appBundleID: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
    var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    var appBuildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    // MARK: - 越狱检测
    var isPirated: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        if getgid() <= 10 { return true }
        if Bundle.main.infoDictionary?["SignerIdentity"] != nil { return true }
        if !_yy_fileExistInMainBundle("_CodeSignature") { return true }
        if !_yy_fileExistInMainBundle("SC_Info") { return true }
        return false
        #endif
    }
    private func _yy_fileExistInMainBundle(_ name: String) -> Bool {
        let bundlePath = Bundle.main.bundlePath
        let path = bundlePath + "/" + name
        return FileManager.default.fileExists(atPath: path)
    }
    // MARK: - 调试检测
    var isBeingDebugged: Bool {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.size
        var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        let sysctlResult = name.withUnsafeMutableBufferPointer { namePtr in
            sysctl(namePtr.baseAddress, 4, &info, &size, nil, 0)
        }
        if sysctlResult != 0 { return false }
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    // MARK: - 内存/CPU
    var memoryUsage: Int64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        if kerr == KERN_SUCCESS { return Int64(info.resident_size) }
        return -1
    }
    var cpuUsage: Float {
        var kr: kern_return_t
        var taskInfo = task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<task_basic_info>.size) / 4
        kr = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), $0, &count)
            }
        }
        if kr != KERN_SUCCESS { return -1 }
        var threadList: thread_act_array_t?
        var threadCount = mach_msg_type_number_t()
        kr = task_threads(mach_task_self_, &threadList, &threadCount)
        if kr != KERN_SUCCESS { return -1 }
        var tot_cpu: Float = 0
        if let threadList = threadList {
            for i in 0..<Int(threadCount) {
                var thinfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                kr = withUnsafeMutablePointer(to: &thinfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadList[i], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                if kr != KERN_SUCCESS { return -1 }
                if (thinfo.flags & TH_FLAGS_IDLE) == 0 {
                    tot_cpu += Float(thinfo.cpu_usage) / Float(TH_USAGE_SCALE)
                }
            }
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threadList), vm_size_t(threadCount) * vm_size_t(MemoryLayout<thread_t>.size))
        }
        return tot_cpu
    }
    // MARK: - 网络指示器计数
    private struct AssociatedKeys {
        static var networkActivityCount = "yy_networkActivityCount"
    }
    private var networkActivityCount: Int {
        get { (objc_getAssociatedObject(self, &AssociatedKeys.networkActivityCount) as? Int) ?? 0 }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.networkActivityCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            DispatchQueue.main.async {
                self.isNetworkActivityIndicatorVisible = newValue > 0
            }
        }
    }
    func incrementNetworkActivityCount() {
        networkActivityCount += 1
    }
    func decrementNetworkActivityCount() {
        networkActivityCount = max(networkActivityCount - 1, 0)
    }
    // MARK: - App Extension 检测
    static var isAppExtension: Bool {
        if Bundle.main.bundlePath.hasSuffix(".appex") { return true }
        if NSClassFromString("UIApplication") == nil { return true }
        return false
    }
    static var sharedExtensionApplication: UIApplication? {
        guard !isAppExtension else { return nil }
        return UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication
    }
} 