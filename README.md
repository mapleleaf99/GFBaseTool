# GFBaseTool

[![Version](https://img.shields.io/cocoapods/v/GFBaseTool.svg?style=flat)](https://cocoapods.org/pods/GFBaseTool)
[![License](https://img.shields.io/cocoapods/l/GFBaseTool.svg?style=flat)](https://cocoapods.org/pods/GFBaseTool)
[![Platform](https://img.shields.io/cocoapods/p/GFBaseTool.svg?style=flat)](https://cocoapods.org/pods/GFBaseTool)

GFBaseTool 是一个面向 iOS 项目的**基础工具库**，封装了日常开发中高频使用的 Extension、线程调度、Toast 提示、网络请求、自定义控件等能力，帮助快速搭建项目基础设施。

- **语言**：Swift 5.0+
- **最低系统**：iOS 12.0+
- **依赖管理**：CocoaPods

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

### 完整安装（Core + Network）

```ruby
platform :ios, '12.0'
use_frameworks!

target 'YourApp' do
  pod 'GFBaseTool'
end
```

### 仅安装基础工具（不含网络层）

```ruby
pod 'GFBaseTool', :subspecs => ['Core']
```

安装后执行：

```bash
cd Example && pod install   # 运行示例工程
pod lib lint GFBaseTool.podspec  # 校验 podspec
```

---

## 模块结构

```
GFBaseTool/
├── Core（基础模块）
│   ├── Config.swift              # 屏幕、安全区、颜色、字体、日志
│   ├── GFGCD.swift               # 线程调度
│   ├── CodableUtil.swift         # JSON 模型转换
│   ├── ToolManager.swift         # 打电话、JSON、敏感词
│   ├── DeviceUtil.swift          # 设备信息
│   ├── UserDefaultsUtil.swift    # 本地存储
│   ├── Debouncer.swift           # 防抖 / 节流
│   ├── Extension/                # 各类扩展
│   ├── CustomView/               # GFButton、GFTextField、GFDottedLine
│   └── Toast/                    # 提示封装
└── Network（网络模块）
    ├── NetworkConfiguration.swift
    ├── BaseResponse.swift
    └── NetWork.swift
```

---

## 快速开始

### 1. 在 AppDelegate 中配置（推荐）

```swift
import GFBaseTool

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // 网络配置（使用 Network 模块时）
    GFNetworkConfiguration.shared = GFNetworkConfiguration(
        baseURL: "https://api.yourserver.com",
        successCode: 0,
        showLoading: true
    )

    // 加载敏感词（可选，需在 bundle 中放置 sensitiveWord.txt）
    ToolManager.reloadSensitiveWords()

    return true
}
```

### 2. 常用代码片段

```swift
import GFBaseTool

// 安全区与布局
let navH = kNavigationHeight
let tabH = kTabBarHeight

// 颜色
let color = UIColor(hex: "#FF5500")

// 字符串校验
if phone.isPhoneNumber { ... }

// 线程
GFGCD.main { /* 更新 UI */ }
GFGCD.mainAfter(1.0) { /* 延时执行 */ }

// Toast
Toast.show("操作成功")
Toast.showProgress()
Toast.hiddenProgress()

// 日志（仅 Debug）
GFFLog("调试信息")
```

---

## 功能说明

### Config — 全局常量

| API | 说明 |
|-----|------|
| `ScreenWidth` / `ScreenHeight` | 屏幕宽高 |
| `safeAreaTop` / `safeAreaBottom` | 安全区高度 |
| `kNavigationHeight` | 导航栏总高度 |
| `kTabBarHeight` | TabBar 总高度 |
| `isPhoneX` | 是否全面屏 |
| `kRGBColorFromHex(rgbValue:)` | 整型 Hex 转颜色 |
| `Font()` / `FontMedium()` / `FontBold()` | 苹方字体 |
| `fontScale()` | 按屏宽等比缩放 |
| `AppVersion` / `AppBundleID` | App 信息 |
| `GFFLog()` | Debug 日志 |

### Extension — 扩展

| 扩展 | 主要能力 |
|------|----------|
| `String` | 本地化、尺寸计算、手机号/邮箱/URL/身份证校验 |
| `Date` | 时间戳、格式化、月份偏移 |
| `UIColor` | Hex 字符串互转 |
| `UIImage` | 九宫格拉伸、纯色图、压缩、圆角 |
| `UIView` | frame 快捷属性、圆角边框、渐变、抖动 |
| `UIApplication` | 获取当前 keyWindow |
| `Array` | 安全下标 |
| `Dictionary` | 转 JSON 字符串 |
| `Optional` | `isNilOrEmpty`、`or()` |

### GFGCD — 线程

```swift
GFGCD.main { }                    // 主线程
GFGCD.async { }                   // 子线程
GFGCD.mainAfter(2.0) { }          // 主线程延时
GFGCD.once(token: "key") { }      // 只执行一次
```

### CodableUtil — 模型转换

```swift
struct User: Codable { var name: String; var age: Int }

let user = CodableUtil.dicWithModel(model: User.self, dic: ["name": "Tom", "age": 18])
let json = CodableUtil.modelToJSONString(user)
let dic  = CodableUtil.modelToDic(user)
```

### ToolManager — 工具方法

```swift
// 打电话（弹窗确认）
ToolManager.callPhone(titleStr: "拨打客服？", phoneNumStr: "10086", viewCtrl: self)

// JSON 互转
let json = ToolManager.getJSONStringFromDic(dic: ["key": "value"])
let dic  = ToolManager.getDicFromJSONString(jsonString: json)

// 敏感词（需在 bundle 添加 sensitiveWord.txt，逗号分隔）
let pass = ToolManager.checkSensitiveWords(wordStr: "内容")
let text = ToolManager.checkSensitiveWordsReplacedWithAsterisk(wordStr: "内容")
```

### DeviceUtil — 设备信息

```swift
DeviceUtil.modelName       // 设备型号
DeviceUtil.systemVersion   // 系统版本
DeviceUtil.isSimulator     // 是否模拟器
DeviceUtil.idfv            // IDFV
```

### UserDefaultsUtil — 本地存储

```swift
UserDefaultsUtil.set("value", forKey: "key")
UserDefaultsUtil.string(forKey: "key")

struct Settings: Codable { var theme: String }
UserDefaultsUtil.setCodable(settings, forKey: "settings")
let s = UserDefaultsUtil.codable(Settings.self, forKey: "settings")
```

### Debouncer / Throttler — 防抖节流

```swift
let debouncer = Debouncer(delay: 0.3)
debouncer.call { /* 搜索请求 */ }

let throttler = Throttler(interval: 1.0)
throttler.call { /* 防重复点击 */ }
```

### Toast — 提示

```swift
Toast.show("提示文字")
Toast.show("底部提示", position: .bottom)
Toast.showProgress()
Toast.hiddenProgress()
```

### 自定义控件

**GFButton** — 支持图文多种布局、点击/长按回调、按下动画

```swift
let btn = GFButton(type: .bottomText)
btn.setTitle("标题", for: .normal)
btn.buttonClick { button in }
btn.onLongPress { button in }
```

**GFTextField** — 占位符颜色、左边距、字数限制、Block 回调

```swift
let field = GFTextField(frame: .zero)
field.placeholder = "请输入"
field.placeholderColor = .gray
field.maxCount = 11
field.textChange { textField in }
```

**GFDottedLine** — 水平虚线

```swift
let line = GFDottedLine(frame: CGRect(x: 0, y: 0, width: 300, height: 1))
line.strokeColor = .lightGray
```

### Network — 网络请求

后端需返回统一格式：

```json
{
  "code": 0,
  "data": { },
  "msg": "success"
}
```

```swift
// 全局配置
GFNetworkConfiguration.shared.baseURL = "https://api.example.com"
GFNetworkConfiguration.shared.successCode = 0

struct User: Codable { var name: String }

// POST（JSON Body）
NetWork.share.postUrlWithModel(
    path: "/user/info",
    type: User.self,
    param: ["id": "1"],
    token: "your_token",
    showLoading: true,
    success: { user in },
    failure: { error in }
)

// GET（URL Query）
NetWork.share.getUrlWithModel(
    path: "/user/list",
    type: [User].self,
    success: { list in },
    failure: { error in }
)
```

错误类型 `GFNetworkError`：

- `.business(code:message:)` — 业务错误（code 非成功码）
- `.emptyData` — data 为空
- `.decodeFailed` — 解析失败

---

## Example 示例工程

仓库自带完整示例，覆盖所有模块：

```bash
git clone https://github.com/mapleleaf99/GFBaseTool.git
cd GFBaseTool/Example
pod install
open GFBaseTool.xcworkspace
```

运行 `GFBaseTool_Example`，首页为功能列表，点击进入各模块演示：

| 示例页 | 演示内容 |
|--------|----------|
| 基础配置 | 屏幕、安全区、App/设备信息 |
| Toast | 文字提示、Loading |
| 字符串校验 | 手机号、邮箱、敏感词 |
| 日期时间 | 时间戳、格式化 |
| 颜色与图片 | Hex 颜色、纯色图 |
| UIView 扩展 | 渐变、抖动、圆角 |
| GCD 线程 | 主线程、异步、延时、once |
| Codable | 字典/Model 互转 |
| UserDefaults | Codable 存储 |
| 防抖与节流 | Debouncer / Throttler |
| 自定义控件 | GFButton、GFTextField、GFDottedLine |
| 网络请求 | 配置说明、响应解析 |
| 工具方法 | JSON、打电话 |

---

## 注意事项

1. **敏感词文件**：在宿主 App 的 main bundle 中添加 `sensitiveWord.txt`，词语以英文逗号 `,` 分隔，然后调用 `ToolManager.reloadSensitiveWords()`。
2. **网络模块**：`post` 默认使用 JSON Body，`get` 使用 URL Query；成功码默认为 `0`，请与后端约定一致。
3. **Toast 依赖**：基于 [Toast-Swift](https://github.com/scalessec/Toast-Swift)，需确保 App 有可见的 keyWindow。
4. **全面屏适配**：优先使用 `safeAreaTop` / `safeAreaBottom`，不要硬编码状态栏高度。
5. **仅 Core 安装**：不需要网络功能时使用 `:subspecs => ['Core']`，可避免引入 Alamofire。

---

## 更新日志

### 0.2.0

- 全面 `public` 化，修复 Pod 集成可用性
- 安全区改为动态计算
- 网络层支持可配置成功码、Loading 开关
- 新增 UIColor/Device/UserDefaults/Debouncer 等工具
- 拆分 Core / Network subspec
- 补全注释、中文文档与 Example 示例

### 0.1.x

- 初始版本

---

## 作者与许可

**作者**：guofeifeng (mapleleaf99@126.com)

**仓库**：https://github.com/mapleleaf99/GFBaseTool

**许可**：MIT License，详见 [LICENSE](LICENSE)
