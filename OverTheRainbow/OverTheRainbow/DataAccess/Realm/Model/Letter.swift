//
//  Letter.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class Letter: RealmModel {
    @Persisted
    var title: String
    
    @Persisted(originProperty: "letters")
    var pet: LinkingObjects<Pet>
    
    @Persisted
    var content: String
    
    @Persisted
    var fileName: String?
    
    @Persisted
    var status: LetterStatus = .temporary
    
    @Persisted
    var createdAt: Date = Date.now
    
    @Persisted
    var updatedAt: Date = Date.now
    
    var date: String {
        return DateConverter.dateToString(self.createdAt)
    }
    
    var imgUrl: URL? {
        guard let fileName = fileName else { return nil }
        return ImageManager.shared?.imagePath.appendingPathComponent(fileName)
    }
    
    convenience init(_ title: String, _ content: String, _ fileName: String?) {
        self.init()
        self.title = title
        self.content = content
        self.fileName = fileName
    }
}
