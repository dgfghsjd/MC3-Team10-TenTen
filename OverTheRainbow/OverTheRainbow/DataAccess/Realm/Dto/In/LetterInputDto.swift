//
//  LetterInputDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import UIKit

struct LetterInputDto {
    let petId: String
    let letter: LetterInput
    
    func toLetter(_ saveImage: (UIImage) throws -> String) -> Letter {
        return letter.toLetter(saveImage)
    }
}

struct LetterInput {
    private(set) var title: String
    private(set) var content: String
    private(set) var image: UIImage?
    
    func toLetter(_ saveImage: (UIImage) throws -> String) -> Letter {
        var fileName: String?
        if let img = self.image {
            fileName = try? saveImage(img)
        }
        return Letter(title, content, fileName)
    }
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    init(title: String, content: String, image: UIImage?) {
        self.title = title
        self.content = content
        self.image = image
    }
}
