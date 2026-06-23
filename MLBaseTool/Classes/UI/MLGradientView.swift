//
//  MLGradientView.swift
//  MLBaseTool
//
//  渐变 Layer / View / ImageView / Button / Label 组件。
//

import UIKit

/// 渐变方向
@objc public enum MLGradientDirection: Int {
    case horizontal
    case vertical
    case diagonalTopToBottom
    case diagonalBottomToTop
}

/// 渐变 CAGradientLayer
public class MLGradientLayer: CAGradientLayer {

    public func ml_setDirection(_ direction: MLGradientDirection) {
        var startPoint = CGPoint(x: 0, y: 0)
        var endPoint = CGPoint(x: 1, y: 0)

        switch direction {
        case .horizontal:
            break
        case .vertical:
            endPoint = CGPoint(x: 0, y: 1)
        case .diagonalTopToBottom:
            endPoint = CGPoint(x: 1, y: 1)
        case .diagonalBottomToTop:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 0)
        }

        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    public func ml_setDirection(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    public func ml_setColors(_ colors: [UIColor]) {
        self.colors = colors.map { $0.cgColor }
    }

    public func ml_setLocations(_ locations: [NSNumber]) {
        self.locations = locations
    }
}

// MARK: - 渐变基类协议

private protocol MLGradientConfigurable: AnyObject {
    var ml_gradientColors: [UIColor] { get set }
    var ml_gradientLayer: MLGradientLayer? { get }
    func ml_applyGradientColors()
}

private extension MLGradientConfigurable where Self: UIView {

    var ml_gradientLayer: MLGradientLayer? {
        layer as? MLGradientLayer
    }

    func ml_applyGradientColors() {
        ml_gradientLayer?.ml_setColors(ml_gradientColors)
    }

    func ml_setupDefaultDirection() {
        ml_gradientLayer?.ml_setDirection(.horizontal)
    }

    func ml_handleTraitChange(_ previous: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previous) {
                ml_applyGradientColors()
            }
        }
    }
}

// MARK: - MLGradientView

open class MLGradientView: UIView, MLGradientConfigurable {

    var ml_gradientColors: [UIColor] = []

    open override class var layerClass: AnyClass {
        MLGradientLayer.self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        ml_setupDefaultDirection()
    }

    public init() {
        super.init(frame: .zero)
        ml_setupDefaultDirection()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func ml_setDirection(_ direction: MLGradientDirection) {
        ml_gradientLayer?.ml_setDirection(direction)
    }

    public func ml_setDirection(startPoint: CGPoint, endPoint: CGPoint) {
        ml_gradientLayer?.ml_setDirection(startPoint: startPoint, endPoint: endPoint)
    }

    @objc public func ml_setColors(_ colors: [UIColor]) {
        ml_gradientColors = colors
        ml_applyGradientColors()
    }

    public func ml_setLocations(_ locations: [NSNumber]) {
        ml_gradientLayer?.ml_setLocations(locations)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ml_handleTraitChange(previousTraitCollection)
    }
}

// MARK: - MLGradientImageView

open class MLGradientImageView: UIImageView, MLGradientConfigurable {

    var ml_gradientColors: [UIColor] = []

    open override class var layerClass: AnyClass {
        MLGradientLayer.self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        ml_setupDefaultDirection()
    }

    public init() {
        super.init(frame: .zero)
        ml_setupDefaultDirection()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func ml_setDirection(_ direction: MLGradientDirection) {
        ml_gradientLayer?.ml_setDirection(direction)
    }

    public func ml_setDirection(startPoint: CGPoint, endPoint: CGPoint) {
        ml_gradientLayer?.ml_setDirection(startPoint: startPoint, endPoint: endPoint)
    }

    public func ml_setColors(_ colors: [UIColor]) {
        ml_gradientColors = colors
        ml_applyGradientColors()
    }

    public func ml_setLocations(_ locations: [NSNumber]) {
        ml_gradientLayer?.ml_setLocations(locations)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ml_handleTraitChange(previousTraitCollection)
    }
}

// MARK: - MLGradientButton

open class MLGradientButton: UIButton, MLGradientConfigurable {

    var ml_gradientColors: [UIColor] = []

    open override class var layerClass: AnyClass {
        MLGradientLayer.self
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        ml_setupDefaultDirection()
    }

    public init() {
        super.init(frame: .zero)
        ml_setupDefaultDirection()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func ml_setDirection(_ direction: MLGradientDirection) {
        ml_gradientLayer?.ml_setDirection(direction)
    }

    public func ml_setColors(_ colors: [UIColor]) {
        ml_gradientColors = colors
        ml_applyGradientColors()
    }

    public func ml_setLocations(_ locations: [NSNumber]) {
        ml_gradientLayer?.ml_setLocations(locations)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ml_handleTraitChange(previousTraitCollection)
    }
}

// MARK: - MLGradientLabel

open class MLGradientLabel: UILabel, MLGradientConfigurable {

    var ml_gradientColors: [UIColor] = []

    open override class var layerClass: AnyClass {
        MLGradientLayer.self
    }

    public init() {
        super.init(frame: .zero)
        ml_setupDefaultDirection()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func ml_setDirection(_ direction: MLGradientDirection) {
        ml_gradientLayer?.ml_setDirection(direction)
    }

    public func ml_setColors(_ colors: [UIColor]) {
        ml_gradientColors = colors
        ml_applyGradientColors()
    }

    public func ml_setLocations(_ locations: [NSNumber]) {
        ml_gradientLayer?.ml_setLocations(locations)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ml_handleTraitChange(previousTraitCollection)
    }
}

// MARK: - MLGradientTextLabel

open class MLGradientTextLabel: UILabel, MLGradientConfigurable {

    var ml_gradientColors: [UIColor] = []

    private lazy var textLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.isWrapped = true
        layer.truncationMode = .end
        layer.contentsScale = UIScreen.main.scale
        layer.rasterizationScale = UIScreen.main.scale
        layer.allowsFontSubpixelQuantization = false
        return layer
    }()

    open override var text: String? {
        didSet { textLayer.string = text }
    }

    open override var font: UIFont! {
        didSet {
            textLayer.font = font
            textLayer.fontSize = font.pointSize
        }
    }

    open override var textAlignment: NSTextAlignment {
        didSet {
            switch textAlignment {
            case .justified: textLayer.alignmentMode = .justified
            case .left: textLayer.alignmentMode = .left
            case .center: textLayer.alignmentMode = .center
            case .right: textLayer.alignmentMode = .right
            case .natural: textLayer.alignmentMode = .natural
            @unknown default: textLayer.alignmentMode = .natural
            }
        }
    }

    open override class var layerClass: AnyClass {
        MLGradientLayer.self
    }

    public init() {
        super.init(frame: .zero)
        ml_gradientLayer?.mask = textLayer
        textColor = .clear
        ml_setupDefaultDirection()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func ml_setTruncationMode(_ mode: CATextLayerTruncationMode) {
        textLayer.truncationMode = mode
    }

    public func ml_setDirection(_ direction: MLGradientDirection) {
        ml_gradientLayer?.ml_setDirection(direction)
    }

    public func ml_setColors(_ colors: [UIColor]) {
        ml_gradientColors = colors
        ml_applyGradientColors()
    }

    public func ml_setLocations(_ locations: [NSNumber]) {
        ml_gradientLayer?.ml_setLocations(locations)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        textLayer.frame = bounds
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        ml_handleTraitChange(previousTraitCollection)
    }
}
