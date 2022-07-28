//
//  DateFormat.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

enum DateFormat {
    case yearMonthDate
    case yearMonth
    case yearMonthKr
    case yearMonthDateHyphen
    
    var value: String {
        get {
            switch (self) {
            case .yearMonth:
                return "yyyy.MM"
            case .yearMonthDate:
                return "yyyy.MM.dd"
            case .yearMonthKr:
                return "yyyy년 MM월"
            case .yearMonthDateHyphen:
                return "yyyy-MM-dd-"
            }
        }
    }
}
