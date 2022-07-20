//
//  Pet.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class Pet: Object {
    @Persisted(primaryKey: true)
    var _id: ObjectId
    
    @Persisted
    var name: String
    
    @Persisted
    var species: String
    
    @Persisted
    var imgUrl: String?
    
    @Persisted
    var birth: Date
    
    @Persisted
    var weight: Double
    
    @Persisted
    var createdAt: Date = Date.now
    
    @Persisted
    var letters: List<Letter>
    
    @Persisted
    var flowerLogs: List<FlowerLog>
    
    
    init(_ name: String, _ species: String, imgUrl: String?, birth: Date, weight: Double) {
        self.birth = birth
        self.species = species
        self.imgUrl = imgUrl
        self.birth = birth
        self.weight = weight
    }
}
