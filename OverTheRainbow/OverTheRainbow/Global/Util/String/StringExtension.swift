//
//  StringExtension.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/29.
// swiftlint:disable force_try

import Foundation
import RealmSwift

extension String {
    func toObjectId() -> ObjectId {
        return try! ObjectId(string: self)
    }
}
