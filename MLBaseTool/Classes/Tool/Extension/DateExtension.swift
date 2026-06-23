//
//  DateExtension.swift
//  MLBaseTool
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
    func ml_string(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        return Date.ml_formatter(format: format).string(from: self)
    }

    /// 时间戳转日期字符串，自动识别秒级/毫秒级时间戳
    static func timeToDate(_ timeStamp: TimeInterval, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let seconds = timeStamp > 1_000_000_000_000 ? timeStamp / 1000 : timeStamp
        let date = Date(timeIntervalSince1970: seconds)
        return date.ml_string(format: dateFormat)
    }

    private static var formatterCache: [String: DateFormatter] = [:]
    private static let formatterLock = NSLock()

    /// 获取缓存的 DateFormatter，线程安全
    static func ml_formatter(format: String) -> DateFormatter {
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

    /// 获取当前时间戳（秒或毫秒）
    static func ml_nowTimestamp(millisecond: Bool = false) -> Int {
        let now = Date()
        if millisecond {
            return Int(now.timeIntervalSince1970 * 1000)
        }
        return Int(now.timeIntervalSince1970)
    }

    /// 拆解为日期分量
    func ml_dateModel() -> MLDateModel {
        let calendar = Calendar.current
        let model = MLDateModel()
        model.timestamp = Int(timeIntervalSince1970)
        model.year = calendar.component(.year, from: self)
        model.month = calendar.component(.month, from: self)
        model.day = calendar.component(.day, from: self)
        model.hour = calendar.component(.hour, from: self)
        model.minute = calendar.component(.minute, from: self)
        model.second = calendar.component(.second, from: self)
        return model
    }

    /// 拆解指定日期为分量
    static func ml_dateModel(from date: Date? = nil) -> MLDateModel {
        return (date ?? Date()).ml_dateModel()
    }

    /// 比较两个时间字符串，判断第一个是否早于第二个
    static func ml_isTimeStringEarlier(
        _ timeStringA: String,
        than timeStringB: String,
        format: String = "yyyy-MM-dd HH:mm:ss"
    ) -> Bool {
        let formatter = ml_formatter(format: format)
        guard let dateA = formatter.date(from: timeStringA),
              let dateB = formatter.date(from: timeStringB) else {
            return false
        }
        return dateA < dateB
    }

    @available(*, deprecated, renamed: "ml_string(format:)")
    func toFormatTime(format: String? = "yyyy-MM-dd HH:mm:ss") -> String {
        return ml_string(format: format ?? "yyyy-MM-dd HH:mm:ss")
    }
}
