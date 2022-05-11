//
//  UIApplicationExtension.swift
//  SECXSwift
//
//  Created by 郭飞锋 on 2022/5/7.
//

import UIKit

extension UIApplication {
    ///获取当前window
   static func currentwindow() -> UIWindow? {
       
       if #available(iOS 14.0, *) {
           if let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene}).compactMap({ $0 }).first?.windows.first {
               return window
           }
       } else if #available(iOS 13.0, *) {
           if let window = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).map({ $0 as? UIWindowScene}).compactMap({ $0 }).first?.windows.filter({ $0.isKeyWindow }).first {
               return window
           }
       }
       
       if let window = UIApplication.shared.delegate?.window {
           return window
       }
       return nil
    }
}
