//
//  RealmModel.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @Persisted(primaryKey: true)
    var _id: ObjectId
}
