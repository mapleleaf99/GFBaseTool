//
//  GFDottedLine.swift
//  GFBaseTool
//
//  水平虚线视图，支持自定义颜色、线宽、虚线样式。
//

import UIKit

/// 水平虚线
public class GFDottedLine: UIView {

    /// 线条颜色
    public var strokeColor: UIColor = kRGBColorFromHex(rgbValue: 0xeeeeee) {
        didSet { shapeLayer.strokeColor = strokeColor.cgColor }
    }

    /// 线宽
    public var lineWidth: CGFloat = 1 {
        didSet { shapeLayer.lineWidth = lineWidth }
    }

    /// 虚线样式，如 [4, 2] 表示 4pt 实线 + 2pt 空白
    public var dashPattern: [NSNumber] = [4, 2] {
        didSet { shapeLayer.lineDashPattern = dashPattern }
    }

    private let shapeLayer = CAShapeLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience init(frame: CGRect, strokeColor: UIColor) {
        self.init(frame: frame)
        self.strokeColor = strokeColor
        shapeLayer.strokeColor = strokeColor.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        let path = CGMutablePath()
        let y = bounds.height / 2
        path.move(to: CGPoint(x: 0, y: y))
        path.addLine(to: CGPoint(x: bounds.width, y: y))
        shapeLayer.path = path
    }

    private func setup() {
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = dashPattern
        layer.addSublayer(shapeLayer)
    }
}
