//
//  LetterStatus.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

enum LetterStatus: String, PersistableEnum {
    case Sent
    case Saved
    case Temporary
}
