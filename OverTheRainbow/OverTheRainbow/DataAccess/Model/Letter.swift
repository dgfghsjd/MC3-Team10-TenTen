//
//  Letter.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class Letter: Object {
    @Persisted(primaryKey: true)
    var _id: ObjectId
    
    @Persisted
    var title: String
    
    @Persisted
    var pet: LinkingObjects<Pet>
    
    @Persisted
    var content: String
    
    @Persisted
    var imgUrl: String?
    
    @Persisted
    var status: LetterStatus = .Temporary
    
    @Persisted
    var createdAt: Date = Date.now
    
    @Persisted
    var updatedAt: Date = Date.now
}
