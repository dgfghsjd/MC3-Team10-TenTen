//
//  FlowerLog.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class FlowerLog: Object{
    @Persisted(primaryKey: true)
    var _id: ObjectId
    
    @Persisted
    var pet: LinkingObjects<Pet>
    
    @Persisted
    var flower: Flower
    
    @Persisted
    var isSent: Bool = false
    
    @Persisted
    var createdAt: Date = Date.now
}
