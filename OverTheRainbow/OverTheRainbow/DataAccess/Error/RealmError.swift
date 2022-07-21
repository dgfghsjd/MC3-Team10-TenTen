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
}
