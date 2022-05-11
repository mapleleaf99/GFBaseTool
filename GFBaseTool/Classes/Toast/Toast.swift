//
//  Toast.swift
//  SECXSwift
//
//  Created by 郭飞锋 on 2022/5/7.
//

import UIKit
import Toast_Swift

class Toast: NSObject {
    static func show(_ message: String?, postion: ToastPosition = .center) {
        UIApplication.currentwindow()?.makeToast(message, position: postion)
    }
    
    static func hidden() {
        UIApplication.currentwindow()?.hideToast()
    }
    
    static func showProgress(_ postion: ToastPosition = .center) {
        UIApplication.currentwindow()?.makeToastActivity(postion)
    }
   
    static func hiddenProgress() {
        UIApplication.currentwindow()?.hideToastActivity()
    }
}

