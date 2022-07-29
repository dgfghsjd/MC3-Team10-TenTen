//
//  Pet.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class Pet: RealmModel {
    @Persisted
    var name: String
    
    @Persisted
    var species: String
    
    @Persisted
    var fileName: String?
    
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
    
    var age: Int {
        return Date.now.years(from: self.birth)
    }
    
    var imgUrl: URL? {
        guard let filename = self.fileName else { return nil }
        return ImageManager.shared?.imagePath.appendingPathComponent(filename)
    }
    
    convenience init(_ name: String, _ species: String, fileName: String?, birth: Date, weight: Double) {
        self.init()
        self.name = name
        self.birth = birth
        self.species = species
        self.fileName = fileName
        self.weight = weight
    }
}
