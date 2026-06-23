//
//  GFGCD.swift
//  GFBaseTool
//
//  GCD 线程调度封装：主线程/子线程切换、延时执行、定时器、单次执行。
//

import Foundation

/// GCD 工具类
public class GFGCD: NSObject {

    private static var onceToken = Set<String>()
    private static let onceLock = NSLock()

    /// 保证指定 token 的 block 全局只执行一次
    /// - Parameters:
    ///   - token: 唯一标识，建议使用 "类名.方法名"
    ///   - block: 需要执行一次的代码块
    public class func once(token: String, block: @escaping () -> Void) {
        onceLock.lock()
        defer { onceLock.unlock() }
        guard !onceToken.contains(token) else { return }
        onceToken.insert(token)
        block()
    }

    /// 异步派发到主线程
    public class func main(_ block: @escaping () -> Void) {
        queue(.main, block: block)
    }

    /// 异步派发到全局子线程
    public class func async(_ block: @escaping () -> Void) {
        queue(.global(), block: block)
    }

    /// 异步派发到指定队列
    public class func queue(_ queue: DispatchQueue, block: @escaping () -> Void) {
        queue.async(execute: block)
    }

    /// 延时后在主线程执行
    public class func mainAfter(_ delay: TimeInterval, block: @escaping () -> Void) {
        after(delay, queue: .main, block: block)
    }

    /// 延时后在全局子线程执行
    public class func asyncAfter(_ delay: TimeInterval, block: @escaping () -> Void) {
        after(delay, queue: .global(), block: block)
    }

    /// 延时后在指定队列执行
    public class func after(_ delay: TimeInterval, queue: DispatchQueue = .main, block: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + delay, execute: block)
    }

    /// 创建 GCD 定时器（秒级）
    /// - Parameters:
    ///   - timerInterval: 触发间隔（秒）
    ///   - queue: 回调队列，传 nil 则在当前线程
    ///   - handler: 定时回调
    /// - Returns: 定时器实例，不使用时应调用 cancel()
    public class func timer(
        _ timerInterval: Int,
        queue: DispatchQueue?,
        handler: DispatchSourceProtocol.DispatchSourceHandler?
    ) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(deadline: .now(), repeating: .seconds(timerInterval))
        timer.setEventHandler(handler: handler)
        timer.resume()
        return timer
    }
}
