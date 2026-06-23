//
//  AppDelegate.swift
//  GFBaseTool Example
//

import UIKit
import GFBaseTool

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 网络全局配置示例（接入真实接口时修改 baseURL）
        GFNetworkConfiguration.shared = GFNetworkConfiguration(
            baseURL: "https://api.example.com",
            successCode: 0,
            defaultHeaders: ["device-type": "ios", "device-info": DeviceUtil.modelName],
            showLoading: true,
            requestTimeout: 30
        )

        // 加载敏感词库（Example 工程已内置 sensitiveWord.txt）
        ToolManager.reloadSensitiveWords()

        // 将 Storyboard 根控制器嵌入导航栏，便于示例页 push
        if let window = window, let root = window.rootViewController, !(root is UINavigationController) {
            window.rootViewController = UINavigationController(rootViewController: root)
        }

        return true
    }
}
