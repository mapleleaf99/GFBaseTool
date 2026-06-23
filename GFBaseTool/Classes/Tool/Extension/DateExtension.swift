//
//  DateExtension.swift
//  GFBaseTool
//
//  Date 扩展：时间戳、日期格式化、月份偏移。
//

import Foundation

public extension Date {

    /// 秒级时间戳字符串（10 位）
    var timeStamp: String {
        return "\(Int(timeIntervalSince1970))"
    }

    /// 毫秒级时间戳字符串（13 位）
    var milliStamp: String {
        return "\(CLongLong(round(timeIntervalSince1970 * 1000)))"
    }

    /// 是否为明天
    var isTomorrow: Bool {
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return false }
        return Calendar.current.isDate(self, inSameDayAs: tomorrow)
    }

    /// 是否为后天
    var isAfterTomorrow: Bool {
        guard let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: Date()) else { return false }
        return Calendar.current.isDate(self, inSameDayAs: dayAfterTomorrow)
    }

    /// 上一个月
    func beforeMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
    }

    /// 下一个月
    func nextMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self) ?? self
    }

    /// 格式化为字符串，默认 yyyy-MM-dd HH:mm:ss
    func gf_string(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        return Date.gf_formatter(format: format).string(from: self)
    }

    /// 时间戳转日期字符串，自动识别秒级/毫秒级时间戳
    static func timeToDate(_ timeStamp: TimeInterval, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let seconds = timeStamp > 1_000_000_000_000 ? timeStamp / 1000 : timeStamp
        let date = Date(timeIntervalSince1970: seconds)
        return date.gf_string(format: dateFormat)
    }

    private static var formatterCache: [String: DateFormatter] = [:]
    private static let formatterLock = NSLock()

    /// 获取缓存的 DateFormatter，线程安全
    static func gf_formatter(format: String) -> DateFormatter {
        formatterLock.lock()
        defer { formatterLock.unlock() }
        if let formatter = formatterCache[format] {
            return formatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        formatterCache[format] = formatter
        return formatter
    }
}
