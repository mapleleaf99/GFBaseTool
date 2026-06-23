//
//  DeviceUtil.swift
//  GFBaseTool
//
//  设备信息工具：型号、系统版本、模拟器判断、IDFV。
//

import UIKit

/// 设备信息工具
public struct DeviceUtil {

    /// 系统版本号，如 "17.0"
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// 设备型号名称，如 "iPhone 15 Pro"，未知型号返回标识符
    public static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? ""
            }
        }
        return mapToDeviceName(machine)
    }

    /// 是否运行在模拟器
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    /// 设备 IDFV（同一厂商 App 共享）
    public static var idfv: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

  /// 将机器标识符映射为可读设备名
    private static func mapToDeviceName(_ identifier: String) -> String {
        switch identifier {
        case "i386", "x86_64", "arm64": return "Simulator"
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
        case "iPhone15,4": return "iPhone 15"
        case "iPhone15,5": return "iPhone 15 Plus"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"
        default: return identifier
        }
    }
}
