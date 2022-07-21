//
//  DateConveter.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

class DateConverter {
    private static let format = "yyyy.MM.dd"
    private static let locale = Locale(identifier: "kr_KR")
    private static let timeZone = TimeZone(abbreviation: "KST")!
    private static let dateFormatter = DateFormatter(locale: locale, timeZone: timeZone, dateFormat: format)
    
    public static func dateToString(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    public static func stringToDate(_ string: String) throws -> Date {
        guard let result = dateFormatter.date(from: string) else {
            throw UtilError.stringToDateFailed
        }
        return result
    }
    
    
}

extension DateFormatter {
    convenience init(locale: Locale, timeZone: TimeZone, dateFormat: String) {
        self.init()
        self.locale = locale
        self.timeZone = timeZone
        self.dateFormat = dateFormat
    }
}
