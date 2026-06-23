//
//  UIViewExtension.swift
//  GFBaseTool
//
//  UIView 扩展：frame 快捷属性、圆角边框、渐变、抖动动画等。
//

import UIKit

public extension UIView {

    // MARK: - Frame 快捷属性

    var x: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }

    var y: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }

    var width: CGFloat {
        get { frame.size.width }
        set { frame.size.width = newValue }
    }

    var height: CGFloat {
        get { frame.size.height }
        set { frame.size.height = newValue }
    }

    var centerX: CGFloat {
        get { center.x }
        set { center.x = newValue }
    }

    var centerY: CGFloat {
        get { center.y }
        set { center.y = newValue }
    }

    // MARK: - IBInspectable

    /// 圆角半径，设置后自动开启 masksToBounds
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    /// 边框宽度
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    /// 边框颜色，未设置时返回 .clear
    @IBInspectable var borderColor: UIColor {
        get {
            guard let cgColor = layer.borderColor else { return .clear }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue.cgColor }
    }

    // MARK: - 圆角与渐变

    /// 设置指定角的圆角
    func setMutiBorderRoundingCorners(_ corner: CGFloat, roundingCorners: UIRectCorner = [.topLeft, .topRight]) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSize(width: corner, height: corner)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    private static var gradientLayerKey: UInt8 = 0

    /// 添加渐变背景层（layout 变化后需调用 updateGradientLayerFrame）
    func addGradientLayer(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
        cornerRadius: CGFloat = 0
    ) {
        removeGradientLayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations ?? [0.0, 1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        objc_setAssociatedObject(self, &UIView.gradientLayerKey, gradientLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @available(*, deprecated, renamed: "addGradientLayer(colors:locations:startPoint:endPoint:cornerRadius:)")
    func addGradientLaye(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint? = nil,
        endPoint: CGPoint? = nil,
        cornerRadius: CGFloat = 0
    ) {
        addGradientLayer(
            colors: colors,
            locations: locations,
            startPoint: startPoint ?? CGPoint(x: 0, y: 0.5),
            endPoint: endPoint ?? CGPoint(x: 1, y: 0.5),
            cornerRadius: cornerRadius
        )
    }

    /// 移除渐变层
    func removeGradientLayer() {
        if let gradientLayer = objc_getAssociatedObject(self, &UIView.gradientLayerKey) as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
            objc_setAssociatedObject(self, &UIView.gradientLayerKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 在 layoutSubviews 中调用以同步渐变层尺寸
    func updateGradientLayerFrame() {
        if let gradientLayer = objc_getAssociatedObject(self, &UIView.gradientLayerKey) as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }

    // MARK: - 工具方法

    /// 移除所有子视图
    func removeAllSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// 查找当前视图所在的 ViewController
    func viewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
}

/// 抖动方向
public enum GFShakeDirection: Int {
    case horizontal
    case vertical
}

public extension UIView {

    /// 抖动动画，常用于表单校验失败提示
    func shake(
        direction: GFShakeDirection = .horizontal,
        times: Int = 5,
        interval: TimeInterval = 0.1,
        offset: CGFloat = 2,
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(withDuration: interval, animations: {
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
            case .vertical:
                self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
            }
        }) { _ in
            if times == 0 {
                UIView.animate(withDuration: interval, animations: {
                    self.layer.setAffineTransform(.identity)
                }, completion: { _ in completion?() })
            } else {
                self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
            }
        }
    }
}
