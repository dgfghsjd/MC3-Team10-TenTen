//
//  File.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/22.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> Array<Element> {
        return Array(self)
    }
}
