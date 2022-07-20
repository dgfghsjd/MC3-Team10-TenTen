//
//  RealmService.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift

class RealmService: DataAccessProvider {
    private let realm: Realm
    private let repository: RealmRepository
    
    func addPet(_ inputDto: PetInputDto) {
        try! realm.write {
            let pet = inputDto.toPet()
            repository.save(pet)
        }
    }
    
    func findPet(id: String) throws -> PetResultDto {
        let objectId = stringToObjectId(id: id)
        
        // 찾는 pet이 없으면 error throw
        guard let pet: Pet = repository.findById(id: objectId) else {
            throw RealmError.petNotFound
        }
        
        return PetResultDto.of(pet: pet)
    }
    
    func findAllPet() -> Array<PetResultDto> {
        let results: Results<Pet> = repository.findAll()
        return Array(results).map { PetResultDto.of(pet: $0) }
    }
    
    func addLetter(_ inputDto: LetterInputDto) throws {
        let petId = stringToObjectId(id: inputDto.petId)
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        let letter = inputDto.toLetter()
        
        try! realm.write {
            pet.letters.append(letter)
        }
    }
    
    func saveLetters(_ ids: String...) throws {
        try! ids.forEach { id in
            let letterId = stringToObjectId(id: id)
            guard let letter: Letter = repository.findById(id: letterId) else {
                throw RealmError.letterNotFound
            }
            
            try! realm.write {
                letter.status = .Saved
            }
        }
    }
    
    func unsaveLetters(_ ids: String...) throws {
        try! ids.forEach { id in
            let letterId = stringToObjectId(id: id)
            guard let letter: Letter = repository.findById(id: letterId) else {
                throw RealmError.letterNotFound
            }
            
            try! realm.write {
                letter.status = .Temporary
            }
        }
    }

    
    private func stringToObjectId(id: String) -> ObjectId {
        return try! ObjectId(string: id)
    }
    
    
    init(_ realm: Realm, _ repository: RealmRepository) {
        self.realm = realm
        self.repository = repository
    }
}
