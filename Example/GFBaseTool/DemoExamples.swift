//
//  DemoExamples.swift
//  GFBaseTool Example
//
//  各模块演示页面实现。
//

import UIKit
import GFBaseTool

// MARK: - 演示页基类

class DemoBaseViewController: UIViewController {

    let scrollView = UIScrollView()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollLayout()
    }

    private func setupScrollLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    func addLabel(_ text: String, font: UIFont = Font(14), color: UIColor = .darkGray) {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
    }

    @discardableResult
    func addButton(_ title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = FontMedium(16)
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(button)
        return button
    }

    func addResultView() -> UILabel {
        let label = UILabel()
        label.font = Font(13)
        label.textColor = .black
        label.numberOfLines = 0
        label.backgroundColor = UIColor(white: 0.95, alpha: 1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.text = "结果将显示在这里"
        stackView.addArrangedSubview(label)
        return label
    }
}

// MARK: - 基础配置

class ConfigDemoViewController: DemoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "基础配置"
        addLabel("屏幕与安全区")
        let result = addResultView()
        result.text = """
        屏幕：\(Int(ScreenWidth)) x \(Int(ScreenHeight))
        是否 iPhone：\(isPhone)
        是否全面屏：\(isPhoneX)
        状态栏高度：\(kStatusBarHeight)
        导航栏高度：\(kNavigationHeight)
        TabBar 高度：\(kTabBarHeight)
        顶部安全区：\(safeAreaTop)
        底部安全区：\(safeAreaBottom)
        缩放比例：\(String(format: "%.2f", scale()))
        """
        addLabel("App 与设备信息")
        addLabel("""
        App 名称：\(AppDisplayName ?? "-")
        版本号：\(AppVersion ?? "-") (\(AppBuildNumber ?? "-"))
        Bundle ID：\(AppBundleID ?? "-")
        设备型号：\(DeviceUtil.modelName)
        系统版本：iOS \(DeviceUtil.systemVersion)
        是否模拟器：\(DeviceUtil.isSimulator)
        IDFV：\(DeviceUtil.idfv)
        """)
    }
}

// MARK: - Toast

class ToastDemoViewController: DemoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toast"
        addLabel("基于 Toast-Swift 封装，自动获取当前 window 显示。")
        addButton("显示文字提示", action: #selector(showToast))
        addButton("显示底部提示", action: #selector(showBottomToast))
        addButton("显示 Loading（2秒后关闭）", action: #selector(showLoading))
    }

    @objc private func showToast() { Toast.show("这是一条居中提示") }
    @objc private func showBottomToast() { Toast.show("底部提示", position: .bottom) }
    @objc private func showLoading() {
        Toast.showProgress()
        GFGCD.mainAfter(2) {
            Toast.hiddenProgress()
            Toast.show("Loading 已关闭")
        }
    }
}

// MARK: - 字符串

class StringDemoViewController: DemoBaseViewController {

    private var resultLabel: UILabel!
    private var inputField: GFTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "字符串校验"
        addLabel("输入内容后点击按钮进行校验。敏感词库：测试、敏感、违规")

        inputField = GFTextField(frame: .zero)
        inputField.borderStyle = .roundedRect
        inputField.placeholder = "请输入手机号或含敏感词的文本"
        inputField.maxCount = 20
        stackView.addArrangedSubview(inputField)

        resultLabel = addResultView()
        addButton("校验手机号", action: #selector(checkPhone))
        addButton("校验邮箱格式", action: #selector(checkEmail))
        addButton("敏感词检测", action: #selector(checkSensitive))
        addButton("敏感词替换", action: #selector(replaceSensitive))
    }

    @objc private func checkPhone() {
        let text = inputField.text ?? ""
        resultLabel.text = text.isPhoneNumber ? "✅ 手机号格式正确" : "❌ 手机号格式错误"
        if !text.isPhoneNumber { inputField.shake() }
    }

    @objc private func checkEmail() {
        let text = inputField.text ?? ""
        resultLabel.text = text.isEmail ? "✅ 邮箱格式正确" : "❌ 邮箱格式错误"
    }

    @objc private func checkSensitive() {
        let text = inputField.text ?? ""
        let pass = ToolManager.checkSensitiveWords(wordStr: text)
        resultLabel.text = pass ? "✅ 未包含敏感词" : "❌ 包含敏感词"
    }

    @objc private func replaceSensitive() {
        let text = inputField.text ?? ""
        resultLabel.text = "替换结果：\(ToolManager.checkSensitiveWordsReplacedWithAsterisk(wordStr: text))"
    }
}

// MARK: - 日期

class DateDemoViewController: DemoBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "日期时间"
        let now = Date()
        let result = addResultView()
        result.text = """
        当前时间：\(now.gf_string())
        秒级时间戳：\(now.timeStamp)
        毫秒时间戳：\(now.milliStamp)
        是否明天：\(now.isTomorrow)
        上个月：\(now.beforeMonth().gf_string(format: "yyyy-MM-dd"))
        下个月：\(now.nextMonth().gf_string(format: "yyyy-MM-dd"))
        时间戳转换：\(Date.timeToDate(1_700_000_000_000))
        """
    }
}

// MARK: - 颜色与图片

class ColorImageDemoViewController: DemoBaseViewController {

    private let colorPreview = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "颜色与图片"
        addLabel("Hex 颜色解析与互转")
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        colorPreview.heightAnchor.constraint(equalToConstant: 60).isActive = true
        colorPreview.layer.cornerRadius = 8
        if let color = UIColor(hex: "#FF5500") {
            colorPreview.backgroundColor = color
            addLabel("UIColor(hex: \"#FF5500\") → \(color.hexString)")
        }
        stackView.addArrangedSubview(colorPreview)

        addLabel("纯色图片（100x40）")
        let imageView = UIImageView(image: UIImage.imageWithColor(color: kRGBColorFromHex(rgbValue: 0x3399FF), size: CGSize(width: 100, height: 40)))
        imageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(imageView)
    }
}

// MARK: - UIView 扩展

class ViewExtDemoViewController: DemoBaseViewController {

    private let demoView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIView 扩展"
        demoView.backgroundColor = UIColor(hex: "#E8F4FF")
        demoView.layer.cornerRadius = 8
        demoView.translatesAutoresizingMaskIntoConstraints = false
        demoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.addArrangedSubview(demoView)

        addButton("添加渐变背景", action: #selector(addGradient))
        addButton("抖动动画", action: #selector(shakeView))
        addButton("设置部分圆角", action: #selector(roundCorners))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        demoView.updateGradientLayerFrame()
    }

    @objc private func addGradient() {
        demoView.addGradientLayer(colors: [UIColor(hex: "#FF6B6B")!, UIColor(hex: "#4ECDC4")!])
    }

    @objc private func shakeView() { demoView.shake() }

    @objc private func roundCorners() {
        demoView.setMutiBorderRoundingCorners(12, roundingCorners: [.topLeft, .topRight])
    }
}

// MARK: - GCD

class GCDDemoViewController: DemoBaseViewController {

    private var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GCD 线程"
        resultLabel = addResultView()
        addButton("主线程更新 UI", action: #selector(runMain))
        addButton("子线程耗时任务", action: #selector(runAsync))
        addButton("2 秒后执行", action: #selector(runAfter))
        addButton("只执行一次（once）", action: #selector(runOnce))
    }

    @objc private func runMain() {
        resultLabel.text = "正在主线程执行..."
        GFGCD.main {
            self.resultLabel.text = "✅ GFGCD.main 成功，主线程：\(Thread.isMainThread)"
        }
    }

    @objc private func runAsync() {
        resultLabel.text = "子线程执行中..."
        GFGCD.async {
            Thread.sleep(forTimeInterval: 1)
            GFGCD.main { self.resultLabel.text = "✅ 子线程任务完成，已切回主线程" }
        }
    }

    @objc private func runAfter() {
        resultLabel.text = "等待 2 秒..."
        GFGCD.mainAfter(2) { self.resultLabel.text = "✅ 2 秒后执行成功" }
    }

    @objc private func runOnce() {
        GFGCD.once(token: "demo.once") {
            GFGCD.main { self.resultLabel.text = "✅ once 已执行（多次点击只生效一次）" }
        }
    }
}

// MARK: - Codable

class CodableDemoViewController: DemoBaseViewController {

    struct User: Codable {
        var name: String
        var age: Int
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Codable"
        let result = addResultView()
        let user = User(name: "锅先生", age: 28)
        let dic: [String: Any] = ["name": "GFBaseTool", "age": 3]
        let fromDic = CodableUtil.dicWithModel(model: User.self, dic: dic)
        result.text = """
        Model → JSON:
        \(CodableUtil.modelToJSONString(user, prettyPrinted: true) ?? "")

        字典 → Model:
        \(fromDic?.name ?? "-"), age=\(fromDic?.age ?? 0)
        """
    }
}

// MARK: - UserDefaults

class UserDefaultsDemoViewController: DemoBaseViewController {

    struct Settings: Codable {
        var theme: String
        var notify: Bool
    }

    private var resultLabel: UILabel!
    private let key = "gf_demo_settings"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UserDefaults"
        resultLabel = addResultView()
        addButton("写入 Codable 对象", action: #selector(save))
        addButton("读取 Codable 对象", action: #selector(load))
        addButton("清除数据", action: #selector(clear))
    }

    @objc private func save() {
        UserDefaultsUtil.setCodable(Settings(theme: "dark", notify: true), forKey: key)
        resultLabel.text = "✅ 已保存 Settings(theme: dark, notify: true)"
    }

    @objc private func load() {
        if let settings = UserDefaultsUtil.codable(Settings.self, forKey: key) {
            resultLabel.text = "✅ theme: \(settings.theme), notify: \(settings.notify)"
        } else {
            resultLabel.text = "❌ 暂无数据，请先写入"
        }
    }

    @objc private func clear() {
        UserDefaultsUtil.remove(forKey: key)
        resultLabel.text = "已清除"
    }
}

// MARK: - 防抖节流

class DebouncerDemoViewController: DemoBaseViewController {

    private var resultLabel: UILabel!
    private let debouncer = Debouncer(delay: 0.5)
    private let throttler = Throttler(interval: 1.0)
    private var debounceCount = 0
    private var throttleCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "防抖与节流"
        addLabel("防抖：0.5 秒内多次点击只执行最后一次\n节流：1 秒内只执行一次")
        resultLabel = addResultView()
        addButton("触发防抖", action: #selector(fireDebounce))
        addButton("触发节流", action: #selector(fireThrottle))
    }

    @objc private func fireDebounce() {
        debounceCount += 1
        resultLabel.text = "防抖点击 \(debounceCount) 次，等待 0.5 秒..."
        debouncer.call { [weak self] in
            guard let self = self else { return }
            self.resultLabel.text = "✅ 防抖完成，共点击 \(self.debounceCount) 次"
        }
    }

    @objc private func fireThrottle() {
        throttleCount += 1
        throttler.call { [weak self] in
            guard let self = self else { return }
            self.resultLabel.text = "✅ 节流执行，累计点击 \(self.throttleCount) 次"
        }
    }
}

// MARK: - 自定义控件

class CustomViewDemoViewController: DemoBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "自定义控件"

        addLabel("GFButton - 点击/长按回调")
        let button = GFButton(type: .bottomText)
        button.setTitle("点我 / 长按", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.buttonClick { _ in Toast.show("点击回调") }
        button.onLongPress { _ in Toast.show("长按回调") }
        stackView.addArrangedSubview(button)

        addLabel("GFTextField - 最多 11 字")
        let field = GFTextField(frame: .zero)
        field.borderStyle = .roundedRect
        field.placeholder = "最多输入 11 个字符"
        field.placeholderColor = .gray
        field.maxCount = 11
        stackView.addArrangedSubview(field)

        addLabel("GFDottedLine")
        let line = GFDottedLine(frame: .zero)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(line)
    }
}

// MARK: - 网络

class NetworkDemoViewController: DemoBaseViewController {

    struct DemoUser: Codable {
        var name: String
        var age: Int
    }

    private var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "网络请求"
        addLabel("后端格式：{ \"code\": 0, \"data\": {...}, \"msg\": \"success\" }")
        resultLabel = addResultView()
        resultLabel.text = """
        baseURL：\(GFNetworkConfiguration.shared.baseURL.isEmpty ? "未配置" : GFNetworkConfiguration.shared.baseURL)
        成功码：\(GFNetworkConfiguration.shared.successCode)
        Loading：\(GFNetworkConfiguration.shared.showLoading)
        """
        addButton("模拟解析响应", action: #selector(parseResponse))
        addButton("模拟业务错误", action: #selector(simulateError))
    }

    @objc private func parseResponse() {
        let json = "{\"code\":0,\"data\":{\"name\":\"锅先生\",\"age\":28},\"msg\":\"success\"}"
        guard let data = json.data(using: .utf8),
              let response = try? JSONDecoder().decode(BaseResponse<DemoUser>.self, from: data),
              let user = response.data else {
            resultLabel.text = "解析失败"
            return
        }
        resultLabel.text = "✅ name: \(user.name), age: \(user.age)"
    }

    @objc private func simulateError() {
        let error = GFNetworkError.business(code: 1001, message: "token 已过期")
        resultLabel.text = "❌ \(error.errorDescription ?? "")"
        Toast.show(error.errorDescription)
    }
}

// MARK: - ToolManager

class ToolManagerDemoViewController: DemoBaseViewController {

    private var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "工具方法"
        resultLabel = addResultView()
        addButton("字典 ↔ JSON", action: #selector(jsonDemo))
        addButton("拨打电话", action: #selector(callPhone))
    }

    @objc private func jsonDemo() {
        let dic: [String: Any] = ["platform": "iOS", "version": "0.2.0"]
        let json = ToolManager.getJSONStringFromDic(dic: dic, prettyPrinted: true)
        resultLabel.text = "JSON:\n\(json)"
    }

    @objc private func callPhone() {
        ToolManager.callPhone(titleStr: "是否拨打 10086？", phoneNumStr: "10086", viewCtrl: self)
    }
}
