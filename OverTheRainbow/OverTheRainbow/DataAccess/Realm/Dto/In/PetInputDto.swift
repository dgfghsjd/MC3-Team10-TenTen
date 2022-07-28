//
//  AddPetInDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import UIKit

// TODO: toPet 리팩토링
struct PetInputDto {
    private(set) var name: String
    private(set) var species: String
    private(set) var birth: Date
    private(set) var weight: Double
    private(set) var image: UIImage?
    
    func toPet(_ saveImage: (UIImage) throws -> String) -> Pet {
        var imgUrl: String?
        if let img = self.image {
            imgUrl = try? saveImage(img)
        }
        return Pet(self.name, self.species, imgUrl: imgUrl, birth: self.birth, weight: self.weight)
    }
    
    
    init(_ name: String, _ species: String, _ birth: Date, _ weight: Double, _ image: UIImage?) {
        self.name = name
        self.species = species
        self.birth = birth
        self.weight = weight
        self.image = image
    }
    
    init(_ name: String, _ species: String, _ birth: Date, _ weight: Double) {
        self.name = name
        self.species = species
        self.birth = birth
        self.weight = weight
    }
}
