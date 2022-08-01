//
//  PetUpdateDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/29.
//

import Foundation
import UIKit

struct PetUpdateDto {
    private(set) var id: String
    private(set) var name: String
    private(set) var species: String
    private(set) var birth: Date
    private(set) var weight: Double
    private(set) var image: UIImage?
    
    public func toPet(pet: Pet, saveImage: (UIImage) throws -> String) -> Pet {
        var fileName: String?
        if let img = self.image {
            fileName = try? saveImage(img)
        }
        pet.name = self.name
        pet.species = self.species
        pet.birth = self.birth
        pet.weight = self.weight
        pet.fileName = fileName
        
        return pet
    }
}
