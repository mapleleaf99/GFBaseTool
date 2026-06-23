//
//  Debouncer.swift
//  MLBaseTool
//
//  防抖与节流工具，常用于搜索框输入、按钮重复点击等场景。
//

import Foundation

/// 防抖器：连续触发时取消上一次任务，只执行最后一次
/// 典型场景：搜索框输入停止 0.3 秒后再请求接口
public class Debouncer {

    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    /// - Parameter delay: 防抖延迟时间（秒）
    public init(delay: TimeInterval) {
        self.delay = delay
    }

    /// 触发防抖任务，会取消尚未执行的上一次任务
    public func call(_ action: @escaping () -> Void) {
        workItem?.cancel()
        let item = DispatchWorkItem(block: action)
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    /// 取消待执行的任务
    public func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}

/// 节流器：在指定时间间隔内最多执行一次
/// 典型场景：按钮 1 秒内只允许点击一次
public class Throttler {

    private let interval: TimeInterval
    private var lastFireDate: Date?

    /// - Parameter interval: 节流间隔（秒）
    public init(interval: TimeInterval) {
        self.interval = interval
    }

    /// 触发节流任务，间隔内重复调用会被忽略
    public func call(_ action: @escaping () -> Void) {
        let now = Date()
        if let last = lastFireDate, now.timeIntervalSince(last) < interval {
            return
        }
        lastFireDate = now
        action()
    }
}
