# MLBaseTool

[![Version](https://img.shields.io/cocoapods/v/MLBaseTool.svg?style=flat)](https://cocoapods.org/pods/MLBaseTool)
[![License](https://img.shields.io/cocoapods/l/MLBaseTool.svg?style=flat)](https://cocoapods.org/pods/MLBaseTool)
[![Platform](https://img.shields.io/cocoapods/p/MLBaseTool.svg?style=flat)](https://cocoapods.org/pods/MLBaseTool)

MLBaseTool 是一个面向 iOS 项目的**基础工具库**，封装 Extension、线程调度、Toast、网络、存储、权限、弹窗、富文本、UI 组件等能力，帮助快速搭建项目基础设施。

- **语言**：Swift 5.0+
- **最低系统**：iOS 12.0+
- **依赖管理**：CocoaPods
- **当前版本**：0.3.0

---

## 目录

- [安装](#安装)
- [模块结构](#模块结构)
- [快速开始](#快速开始)
- [功能说明](#功能说明)
- [Example 示例工程](#example-示例工程)
- [注意事项](#注意事项)
- [更新日志](#更新日志)
- [作者与许可](#作者与许可)

---

## 安装

### 完整安装（默认全部子模块）

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'MLBaseTool', '~> 0.3.0'
end
```

### 按需安装子模块

```ruby
# 仅基础工具
pod 'MLBaseTool', :subspecs => ['Core']

# 基础 + 存储 + UI
pod 'MLBaseTool', :subspecs => ['Core', 'Storage', 'UI']
```

| Subspec | 说明 | 主要依赖 |
|---------|------|----------|
| `Core` | Extension、GCD、Toast、自定义控件、富文本等 | Toast-Swift |
| `Storage` | Keychain、文件缓存 | Core |
| `Permission` | 相机、相册、定位、麦克风、通知权限 | Core |
| `UI` | 空状态、键盘、弹窗、渐变组件 | Core |
| `Network` | 网络请求封装 | Core、Alamofire |

安装后校验：

```bash
pod lib lint MLBaseTool.podspec
```

---

## 模块结构

```
MLBaseTool/
├── Core
│   ├── Config / MLGCD / CodableUtil / ToolManager
│   ├── DeviceUtil / UserDefaultsUtil / Debouncer / AppUtil
│   ├── Extension/          # String、Date、UIView、UIColor 等
│   ├── Attributed/         # 链式富文本 MLAttributedMaker
│   ├── CustomView/         # MLButton、MLTextField、MLDottedLine
│   └── Toast/
├── Storage
│   ├── KeychainUtil
│   └── FileUtil
├── Permission
│   └── PermissionUtil
├── UI
│   ├── MLEmptyView / KeyboardUtil / MLKeyboardManager
│   ├── MLGradientView 系列
│   └── Alert/            # MLAlertView、MLAlertObject、MLAlertManager
└── Network
    ├── MLNetworkConfiguration
    ├── BaseResponse
    └── NetWork
```

---

## 快速开始

### AppDelegate 配置

```swift
import MLBaseTool

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    MLNetworkConfiguration.shared = MLNetworkConfiguration(
        baseURL: "https://api.yourserver.com",
        successCode: 0,
        showLoading: true
    )

    ToolManager.reloadSensitiveWords()
    return true
}
```

### 常用片段

```swift
import MLBaseTool

// 布局与安全区
let navH = kNavigationHeight

// 颜色与字体
let color = UIColor(hex: "#FF5500")
let titleFont = FontMedium(16)

// 线程与提示
MLGCD.main { Toast.show("完成") }

// 富文本
let att = "标题".ml_makeAttributed { make in
    make.font(Font(14)).foregroundColor(.gray).allRange()
}

// 弹窗
let alert = MyAlertObject(param: "提示")
alert.showAlertObject()
```

---

## 功能说明

### Config — 全局常量

| API | 说明 |
|-----|------|
| `ScreenWidth` / `ScreenHeight` | 屏幕宽高 |
| `safeAreaTop` / `safeAreaBottom` | 安全区 |
| `kNavigationHeight` / `kTabBarHeight` | 导航栏、TabBar 高度 |
| `kRGBColorFromHex` / `Font()` | 颜色、苹方字体 |
| `MLLog()` | Debug 日志 |

### Extension

| 扩展 | 能力 |
|------|------|
| `String` | 校验、尺寸计算、`ml_makeAttributed`、日期解析 |
| `Date` | 时间戳、格式化、`ml_dateModel` |
| `UIColor` / `UIImage` / `UIView` | Hex、压缩、圆角阴影、`ml_onTap`、Xib 加载 |
| `UIViewController` | `ml_currentViewController()` 等 |
| `Array` | 安全下标、`ml_unique()` |

### 富文本 — MLAttributedMaker

```swift
let att = "Hello MLBaseTool".ml_makeAttributed { make in
    make.font(Font(16)).foregroundColor(.darkGray).allRange()
    make.foregroundColor(.systemBlue).font(FontBold(16)).inRange(of: "ML")
}

// 关键词高亮
NSMutableAttributedString.ml_text("搜索内容").ml_highlight(keyword: "搜索", color: .red)

// HTML 转富文本
let html = NSMutableAttributedString.ml_fromHTML("<b>粗体</b>", fontSize: 14)
```

### Alert — 弹窗体系

```swift
// 业务弹窗继承 MLAlertObject
class MyAlert: MLAlertObject {
    override func showAlertViewClass(param: Any?) -> MLAlertView? {
        let view = MyAlertView()
        view.updateParam(param)
        return view
    }
}

let alert = MyAlert(param: "内容")
alert.priority = .hight
alert.isClickEmptyForClose = true
alert.showAlertObject()
```

### UI 组件

```swift
// 空状态
view.ml_showEmpty(message: "暂无数据", buttonTitle: "重试") { /* 刷新 */ }
view.ml_hideEmpty()

// 键盘
KeyboardUtil.enableDismissOnTap(view)
KeyboardUtil.adjustScrollView(scrollView)

// 渐变
let gradient = MLGradientView()
gradient.ml_setColors([.red, .orange])
gradient.ml_setDirection(.vertical)
```

### Storage

```swift
KeychainUtil.save(token, forKey: "user_token")
let token = KeychainUtil.read(forKey: "user_token")

FileUtil.cacheSize()   // 缓存大小
FileUtil.clearCache()  // 清理缓存
```

### Permission

```swift
PermissionUtil.request(.camera) { status in
    switch status {
    case .authorized: break
    case .denied: PermissionUtil.openSettings()
    default: break
    }
}
```

### Network

后端统一格式：`{ "code": 0, "data": {}, "msg": "success" }`

```swift
NetWork.share.postUrlWithModel(
    path: "/user/info",
    type: User.self,
    param: ["id": "1"],
    token: "your_token",
    success: { user in },
    failure: { error in }
)
```

### 其他

- **MLGCD**：`main` / `async` / `mainAfter` / `once`
- **CodableUtil**：字典、JSON、Model 互转
- **ToolManager**：打电话、JSON、敏感词过滤
- **Debouncer / Throttler**：防抖、节流
- **Toast**：文字提示与 Loading

---

## Example 示例工程

```bash
git clone https://github.com/mapleleaf99/MLBaseTool.git
cd MLBaseTool/Example
pod install
open MLBaseTool.xcworkspace
```

运行 `MLBaseTool_Example`，首页列出各模块演示入口，包括：基础配置、Toast、字符串与富文本、日期、UIView、GCD、Codable、UserDefaults、Keychain、文件缓存、权限、键盘、空状态、Alert 弹窗、渐变控件、网络等。

---

## 注意事项

1. **敏感词**：在宿主 App 的 main bundle 放置 `sensitiveWord.txt`（英文逗号分隔），调用 `ToolManager.reloadSensitiveWords()`。
2. **网络模块**：`post` 使用 JSON Body，`get` 使用 URL Query；成功码默认 `0`，需与后端一致。
3. **Toast**：依赖 [Toast-Swift](https://github.com/scalessec/Toast-Swift)，需有可见 keyWindow。
4. **全面屏**：使用 `safeAreaTop` / `safeAreaBottom`，勿硬编码状态栏高度。
5. **弹窗富文本链式写法**：先 `make.font().foregroundColor()` 设置属性，最后调用 `allRange()` 或 `inRange()` 应用。

---

## 更新日志

### 0.3.0

- 库重命名为 **MLBaseTool**（原 GFBaseTool）
- API 前缀统一为 `ml_`，类名统一为 `ML` 前缀
- 新增 Alert 弹窗体系、富文本、渐变组件、空状态、键盘处理
- 新增 Storage（Keychain、文件）、Permission 子模块
- 补全 Example 演示与文档

### 0.2.0

- 全面 public 化，网络层可配置
- 拆分 Core / Network subspec
- 新增 Device、UserDefaults、Debouncer 等

### 0.1.x

- 初始版本（以 GFBaseTool 发布）

---

## 作者与许可

**作者**：[叫我锅先生](https://github.com/mapleleaf99) / mapleleaf99

**邮箱**：mapleleaf99@126.com

**仓库**：https://github.com/mapleleaf99/MLBaseTool

**许可**：MIT License，详见 [LICENSE](LICENSE)
