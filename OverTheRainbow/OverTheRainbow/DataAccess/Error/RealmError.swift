//
//  RealmError.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation

enum RealmError: String, Error {
    case petNotFound = "펫이 존재하지 않음"
    case letterNotFound = "편지가 존재하지 않음"
    case flowerNotFound = "꽃이 존재하지 않음"
    case illegalDateArgument = "올바르지 않은 Date 입력"
    case wordNotFound = "DB에 격려의 말이 없음"
    case letterAlreadySent = "이미 보낸 편지는 수정할 수 없습니다."
    case letterAlreadySaved = "저장한 편지는 수정할 수 없습니다."
}
