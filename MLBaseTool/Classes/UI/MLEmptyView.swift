//
//  MLEmptyView.swift
//  MLBaseTool
//
//  空状态视图，用于列表无数据、网络失败等场景。
//

import UIKit

/// 空状态视图
public class MLEmptyView: UIView {

    public var message: String? {
        didSet { messageLabel.text = message }
    }

    public var image: UIImage? {
        didSet { imageView.image = image }
    }

    public var buttonTitle: String? {
        didSet {
            actionButton.setTitle(buttonTitle, for: .normal)
            actionButton.isHidden = buttonTitle == nil
        }
    }

    public var onAction: (() -> Void)?

    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private let stackView = UIStackView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    public convenience init(message: String, image: UIImage? = nil, buttonTitle: String? = nil) {
        self.init(frame: .zero)
        self.message = message
        self.image = image
        self.buttonTitle = buttonTitle
        messageLabel.text = message
        imageView.image = image
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.isHidden = buttonTitle == nil
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear

        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.isHidden = true

        messageLabel.font = Font(14)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        actionButton.titleLabel?.font = FontMedium(15)
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        actionButton.isHidden = true

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.isHidden = image == nil
    }

    @objc private func actionTapped() {
        onAction?()
    }
}

// MARK: - UIView 便捷方法

public extension UIView {

    private static var gfEmptyViewKey: UInt8 = 0

    /// 显示空状态视图
    func ml_showEmpty(
        message: String,
        image: UIImage? = nil,
        buttonTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        ml_hideEmpty()
        let emptyView = MLEmptyView(message: message, image: image, buttonTitle: buttonTitle)
        emptyView.onAction = onAction
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        objc_setAssociatedObject(self, &UIView.gfEmptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    /// 隐藏空状态视图
    func ml_hideEmpty() {
        if let emptyView = objc_getAssociatedObject(self, &UIView.gfEmptyViewKey) as? MLEmptyView {
            emptyView.removeFromSuperview()
            objc_setAssociatedObject(self, &UIView.gfEmptyViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
