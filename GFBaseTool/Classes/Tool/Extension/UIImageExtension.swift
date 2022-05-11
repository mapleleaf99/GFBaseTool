//
//  UIImageExtension.swift
//  SwiftDemo
//
//  Created by yun on 2021/8/12.
//

import UIKit

extension UIImage {
    /// 对指定图片进行拉伸
    func resizableImage(name: String) -> UIImage {
        var normal = UIImage(named: name)!
        let imageWidth = normal.size.width * 0.5
        let imageHeight = normal.size.height * 0.5
        normal = resizableImage(withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth))
        return normal
    }
    
    ///imageWithColor // 颜色转换成UIImage类型.
    class func imageWithColor(color: UIColor,sizes:CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: sizes.width, height: sizes.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
