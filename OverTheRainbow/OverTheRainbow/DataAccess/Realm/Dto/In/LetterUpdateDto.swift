//
//  LetterUpdateDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/30.
//

import Foundation
import UIKit

struct LetterUpdateDto {
    private(set) var id: String
    private(set) var title: String
    private(set) var content: String
    private(set) var image: UIImage?
    
    public func toLetter(letter: Letter, saveImage: (UIImage) throws -> String) -> Letter {
        var fileName: String?
        if let img = self.image {
            fileName = try? saveImage(img)
        }
        letter.title = self.title
        letter.content = self.content
        letter.fileName = fileName
        
        return letter
    }
}
