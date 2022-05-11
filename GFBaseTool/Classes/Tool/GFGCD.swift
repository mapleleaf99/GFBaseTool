//
//  GFGCD.swift
//  Yoga
//
//  Created by 叫我锅先生 on 2019/4/20.
//  Copyright © 2019 叫我锅先生. All rights reserved.
//

import Foundation

public class GFGCD: NSObject {
    static private var onceToken = [String]()
    public class func once(token: String, block: @escaping () -> Void){
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if onceToken.contains(token) { return }
        onceToken.append(token)
        block()
    }
    
    /// 主线程 - 异步
    ///
    /// - Parameter block: block
    public class func main(_ block : @escaping ()->Void){
        queue(DispatchQueue.main, block: block)
    }
    
    /// 子线程 - 异步
    ///
    /// - Parameter block: block
    public class func async(_ block : @escaping ()->Void){
        queue(DispatchQueue.global(), block: block)
    }
    
    /// 指定线程 - 异步
    ///
    /// - Parameters:
    ///   - queue: queue
    ///   - block: block
    public class func queue(_ queue : DispatchQueue,block: @escaping ()->Void){
        queue.async(execute: block)
    }
    
    
    /// 主线程after  - 异步
    ///
    /// - Parameters:
    ///   - delay: 延时时间
    ///   - block: block
    public class func mainAfter(_ delay: TimeInterval,block : @escaping ()->Void){
        after(delay, block: block)
    }
    
    
    /// 主线程after  - 异步
    ///
    /// - Parameters:
    ///   - delay: delay
    ///   - block: block
    public class func asyncAfter(_ delay: TimeInterval,block : @escaping ()->Void){
        after(delay, queue: DispatchQueue.global(), block: block)
    }
    
    /// 自定义线程after  - 异步
    ///
    /// - Parameters:
    ///   - delay: delay
    ///   - queue: queue
    ///   - block: block
    public class func after(_ delay : TimeInterval, queue : DispatchQueue = DispatchQueue.main ,block : @escaping ()->Void){
        queue.asyncAfter(deadline: DispatchTime.now() + delay , execute: block)
    }
    
    
    /// GCD定时器
    ///
    /// - Parameters:
    ///   - timerInterval: 时间
    ///   - queue: queue
    ///   - handler: 处理
    /// - Returns: timer
    public class func timer(_ timerInterval : Int, queue : DispatchQueue?,handler: DispatchSourceProtocol.DispatchSourceHandler?) -> DispatchSourceTimer{
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(deadline: .now(), repeating: .seconds(timerInterval))
        timer.setEventHandler(handler: handler)
        timer.resume()
        return timer
    }
}
