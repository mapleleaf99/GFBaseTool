//
//  UIViewExtension.swift
//  LvboLive
//
//  Created by 叫我锅先生 on 2021/4/15.
//  Copyright © 2021 叫我锅先生. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: - 常用位置属性
    public var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    public var y:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    // MARK: - 常用方法
    
    /// 设置上下两个圆角
    /// - Parameters:
    ///   - corner: 圆角
    ///   - roundingCorners: 哪个位置的圆角
    func setMutiBorderRoundingCorners(_ corner: CGFloat, roundingCorners: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]) {

        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: corner, height: corner))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    /// 添加渐变颜色
    ///
    /// - Parameters:
    ///   - colors: 【颜色】
    ///   - locations: 【位置】
    ///   - startPoint: 起点
    ///   - endPoint: 终点
    ///   - cornerRadius: 圆角
    func addGradientLaye(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, cornerRadius: CGFloat = 0){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations ?? [0.0, 1.0]
        gradientLayer.cornerRadius = cornerRadius
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    ///移除所有的子类
    func removeAllSubViews() {
        for view: UIView in subviews {
            view.removeFromSuperview()
        }
    }
    
    ///查找vc
    func viewController() ->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        
        return nil
    }
}

/// 抖动方向
///
/// - horizontal: 水平抖动
/// - vertical:   垂直抖动
public enum GFShakeDirection: Int {
    case horizontal
    case vertical
}

//抖动view
extension UIView {
    /// GFF 扩展UIView增加抖动方法
    ///
    /// - Parameters:
    ///   - direction:  抖动方向    默认水平方向
    ///   - times:      抖动次数    默认5次
    ///   - interval:   每次抖动时间 默认0.1秒
    ///   - offset:     抖动的偏移量 默认2个点
    ///   - completion: 抖动结束回调
    public func shake(direction: GFShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, offset: CGFloat = 2, completion: (() -> Void)? = nil) {
        
        //移动视图动画（一次）
        UIView.animate(withDuration: interval, animations: {
            switch direction {
                case .horizontal:
                    self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
                case .vertical:
                    self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
            }
            
        }) { (complete) in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) in
                    completion?()
                })
            }
            
            //如果当前不是最后一次，则继续动画，偏移位置相反
            else {
                self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
            }
        }
    }

    
}

