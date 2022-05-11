//
//  DateExtension.swift
//  SwiftDemo
//
//  Created by yun on 2021/8/12.
//

import Foundation

extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    public var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    public var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 是否后天
    public var isAfterTomorrow: Bool {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        return format.string(from: self) == format.string(from: tomorrow!)
    }
    
    /// 获取上一个月
    func beforeMonth() -> Date {
        let calendar = Calendar.current
        var offsetComponent = DateComponents()
        offsetComponent.month = -1
        return calendar.date(byAdding: offsetComponent, to: self, wrappingComponents: false)!
    }
    
    /// 获取下个月
    func nextMonth() -> Date{
        let calendar = Calendar.current
        var offsetComponent = DateComponents()
        offsetComponent.month = 1
        return calendar.date(byAdding: offsetComponent, to: self, wrappingComponents: false)!
    }
    
    /// 时间戳->date
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - dateFormat: 日期格式
    /// - Returns: 日期
    static func timeToDate(_ timeStamp: TimeInterval, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let date = Date(timeIntervalSince1970: (timeStamp / 1000))
        let format = DateFormatter()
        format.dateFormat = dateFormat
        return format.string(from: date)
    }
}
