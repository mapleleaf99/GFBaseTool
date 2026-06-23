//
//  UIViewExtension.swift
//  MLBaseTool
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

    // MARK: - 圆角 / 边框 / 阴影

    /// 添加圆角
    func ml_addCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    /// 添加指定角的圆角
    func ml_addCorner(_ radius: CGFloat, corners: CACornerMask) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }

    /// 添加边框
    func ml_addBorder(_ width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    /// 添加阴影
    func ml_addShadow(
        _ radius: CGFloat,
        color: UIColor,
        shadowOffset: CGSize = .zero,
        shadowOpacity: Float = 1.0
    ) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
    }

    /// 同时添加阴影和圆角
    func ml_addShadowAndCorner(
        shadowRadius: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat,
        shadowOffset: CGSize = .zero,
        shadowOpacity: Float = 1.0
    ) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
    }

    // MARK: - 点击回调

    private struct MLTapAssociatedKeys {
        static var onTapKey: UInt8 = 0
    }

    @discardableResult
    func ml_onTap(_ block: (() -> Void)?) -> Self {
        if objc_getAssociatedObject(self, &MLTapAssociatedKeys.onTapKey) != nil {
            if let control = self as? UIControl {
                control.removeTarget(self, action: #selector(ml_didOnTap), for: .touchUpInside)
            } else {
                gestureRecognizers?
                    .filter { $0 is MLAssociatedTapGestureRecognizer }
                    .forEach { removeGestureRecognizer($0) }
            }
            objc_setAssociatedObject(self, &MLTapAssociatedKeys.onTapKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }

        guard let block = block else { return self }
        isUserInteractionEnabled = true

        if let control = self as? UIControl {
            control.addTarget(self, action: #selector(ml_didOnTap), for: .touchUpInside)
        } else {
            let tap = MLAssociatedTapGestureRecognizer(target: self, action: #selector(ml_didOnTap))
            addGestureRecognizer(tap)
        }

        objc_setAssociatedObject(self, &MLTapAssociatedKeys.onTapKey, block, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }

    @objc private func ml_didOnTap() {
        if let block = objc_getAssociatedObject(self, &MLTapAssociatedKeys.onTapKey) as? (() -> Void) {
            block()
        }
    }

    // MARK: - Xib 加载

    /// 获取与类名同名的 Nib
    class func ml_loadNib(in bundle: Bundle? = nil) -> UINib {
        let nibBundle = bundle ?? Bundle(for: Self.self)
        return UINib(nibName: String(describing: Self.self), bundle: nibBundle)
    }

    /// 从 Xib 创建实例
    @objc class func ml_viewFromXib(in bundle: Bundle? = nil) -> Self? {
        let nibBundle = bundle ?? Bundle(for: Self.self)
        return nibBundle.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?.first as? Self
    }

    @available(*, deprecated, renamed: "ml_viewFromXib(in:)")
    @objc class func loadXib() -> Self? {
        return ml_viewFromXib()
    }

    /// 是否存在与类名同名的 xib
    class func ml_checkExistXib(in bundle: Bundle? = nil) -> Bool {
        let nibBundle = bundle ?? Bundle(for: Self.self)
        return nibBundle.path(forResource: String(describing: Self.self), ofType: "nib") != nil
    }

    /// 根据固定宽度计算 Auto Layout 高度
    func ml_calculateHeight(width: CGFloat) -> CGFloat {
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
    }
}

/// 用于 ml_onTap 关联的手势识别器
public class MLAssociatedTapGestureRecognizer: UITapGestureRecognizer {}

/// 抖动方向
public enum MLShakeDirection: Int {
    case horizontal
    case vertical
}

public extension UIView {

    /// 抖动动画，常用于表单校验失败提示
    func shake(
        direction: MLShakeDirection = .horizontal,
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
