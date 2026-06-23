//
//  UIViewControllerExtension.swift
//  MLBaseTool
//
//  UIViewController 扩展：获取当前可见控制器、导航控制器等。
//

import UIKit

public extension UIViewController {

    /// 获取 keyWindow
    @objc static func ml_keyWindow() -> UIWindow? {
        return UIWindow.ml_keyWindow()
    }

    /// 获取 root view controller
    @objc static func ml_rootViewController() -> UIViewController? {
        return ml_keyWindow()?.rootViewController
    }

    /// 获取当前可见的 view controller
    @objc static func ml_currentViewController() -> UIViewController? {
        return ml_findTopViewController(from: ml_rootViewController())
    }

    /// 获取当前 navigation controller
    @objc static func ml_currentNavigationController() -> UINavigationController? {
        guard let currentVC = ml_currentViewController() else { return nil }
        return currentVC as? UINavigationController ?? currentVC.navigationController
    }

    /// 获取当前最上层的控制器
    @objc static func ml_topMostController() -> UIViewController? {
        return ml_currentViewController()
    }
}

private extension UIViewController {

    static func ml_findTopViewController(from rootVC: UIViewController?) -> UIViewController? {
        guard let rootVC else { return nil }

        if let presentedVC = rootVC.presentedViewController {
            return ml_findTopViewController(from: presentedVC)
        }

        if let navVC = rootVC as? UINavigationController {
            return ml_findTopViewController(from: navVC.visibleViewController ?? navVC.topViewController ?? navVC)
        }

        if let tabVC = rootVC as? UITabBarController {
            return ml_findTopViewController(from: tabVC.selectedViewController ?? tabVC)
        }

        if let splitVC = rootVC as? UISplitViewController, let lastVC = splitVC.viewControllers.last {
            return ml_findTopViewController(from: lastVC)
        }

        if let lastChild = rootVC.children.last, lastChild !== rootVC {
            return ml_findTopViewController(from: lastChild)
        }

        return rootVC
    }
}
