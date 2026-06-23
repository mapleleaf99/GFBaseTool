//
//  ViewController.swift
//  GFBaseTool Example
//
//  示例入口：以列表形式展示各模块的演示页面。
//

import UIKit
import GFBaseTool

/// 演示项数据模型
struct DemoItem {
    let title: String
    let subtitle: String
    let viewController: () -> UIViewController
}

/// 示例首页：功能列表
class ViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let demos: [DemoItem] = [
        DemoItem(title: "基础配置", subtitle: "屏幕、安全区、App 信息、设备信息") {
            ConfigDemoViewController()
        },
        DemoItem(title: "Toast 提示", subtitle: "文字提示、Loading 菊花") {
            ToastDemoViewController()
        },
        DemoItem(title: "字符串校验", subtitle: "手机号、邮箱、URL、敏感词") {
            StringDemoViewController()
        },
        DemoItem(title: "日期时间", subtitle: "时间戳、格式化、月份偏移") {
            DateDemoViewController()
        },
        DemoItem(title: "颜色与图片", subtitle: "Hex 颜色、纯色图片、圆角") {
            ColorImageDemoViewController()
        },
        DemoItem(title: "UIView 扩展", subtitle: "圆角、渐变、抖动动画") {
            ViewExtDemoViewController()
        },
        DemoItem(title: "GCD 线程", subtitle: "主线程、延时、异步") {
            GCDDemoViewController()
        },
        DemoItem(title: "Codable 转换", subtitle: "字典/Data ↔ Model") {
            CodableDemoViewController()
        },
        DemoItem(title: "UserDefaults", subtitle: "基础类型与 Codable 存储") {
            UserDefaultsDemoViewController()
        },
        DemoItem(title: "防抖与节流", subtitle: "Debouncer / Throttler") {
            DebouncerDemoViewController()
        },
        DemoItem(title: "自定义控件", subtitle: "GFButton、GFTextField、GFDottedLine") {
            CustomViewDemoViewController()
        },
        DemoItem(title: "网络请求", subtitle: "配置说明与响应解析演示") {
            NetworkDemoViewController()
        },
        DemoItem(title: "工具方法", subtitle: "JSON 转换、打电话") {
            ToolManagerDemoViewController()
        }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GFBaseTool 示例"
        view.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = demos[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = demos[indexPath.row].viewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
