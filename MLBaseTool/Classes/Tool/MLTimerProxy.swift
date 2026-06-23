//
//  MLTimerProxy.swift
//  MLBaseTool
//
//  Timer 代理，避免 target-self 循环引用。
//

import Foundation

/// Timer 代理，通过 weak target 避免循环引用
public class MLTimerProxy {

    public var timer: Timer?
    private var interval: TimeInterval = 1.0
    private var timerAction: (() -> Void)?

    public init(target: AnyObject, selector: Selector, interval: TimeInterval = 1.0) {
        self.interval = interval
        timerAction = { [weak target] in
            if let target = target, target.responds(to: selector) {
                _ = target.perform(selector)
            }
        }
    }

    public init(interval: TimeInterval = 1.0, action: @escaping () -> Void) {
        self.interval = interval
        timerAction = action
    }

    public func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.timerFired()
        }
    }

    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func timerFired() {
        timerAction?()
    }

    deinit {
        timer?.invalidate()
    }
}
