//
//  RealmService.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//
// swiftlint:disable force_try

import Foundation
import RealmSwift

// TODO: Service 구현체 refactor
// TODO: updatedAt 구현
// TODO: toObjectId() 메서드로 변환
class RealmService: DataAccessService {
    private let realm: Realm
    private let repository: RealmRepository
    private let imageManager: ImageManager = ImageManager.shared!
    
    func addPet(_ inputDto: PetInputDto) -> String {
        try! realm.write {
            let pet = inputDto.toPet(imageManager.saveImage)
            return repository.save(pet)
        }
    }
    
    func updatePet(_ inputDto: PetUpdateDto) throws -> String {
        let petId: ObjectId = inputDto.id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        if let imgUrl = pet.imgUrl {
            try! imageManager.deleteFile(imgUrl)
        }

        try! realm.write {
            let updatedPet = inputDto.toPet(pet: pet, saveImage: imageManager.saveImage)
            repository.update(updatedPet)
        }
        return pet.id
    }
    
    func deletePet(_ id: String) throws {
        let petId = id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        try! realm.write {
            repository.delete(pet)
        }
    }
    
    func findPet(id: String) throws -> PetResultDto {
        let objectId = id.toObjectId()
        
        // 찾는 pet이 없으면 error throw
        guard let pet: Pet = repository.findById(id: objectId) else {
            throw RealmError.petNotFound
        }
        return PetResultDto.of(pet: pet)
    }
    
    func findAllPet() -> [PetResultDto] {
        let results: Results<Pet> = repository.findAll()
            .sorted(byKeyPath: "createdAt", ascending: false)
        return results.toArray()
            .map { PetResultDto.of(pet: $0) }
    }
    
    func addLetter(_ inputDto: LetterInputDto) throws -> String {
        let petId = inputDto.petId.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        let letter = inputDto.toLetter(imageManager.saveImage)
        
        try! realm.write {
            pet.letters.append(letter)
        }
        return letter.id
    }
    
    func findLetter(_ letterId: String) throws -> LetterResultDto {
        let letterObjId = letterId.toObjectId()
        
        guard let letter: Letter = repository.findById(id: letterObjId) else {
            throw RealmError.letterNotFound
        }
        
        return LetterResultDto.of(letter)
    }
    
    func saveLetters(_ ids: String...) throws {
        try! ids.forEach { id in
            let letterId = id.toObjectId()
            guard let letter: Letter = repository.findById(id: letterId) else {
                throw RealmError.letterNotFound
            }
            
            try! realm.write {
                letter.status = .saved
            }
        }
    }
    
    func unsaveLetters(_ ids: String...) throws {
        try! ids.forEach { id in
            let letterId = id.toObjectId()
            guard let letter: Letter = repository.findById(id: letterId) else {
                throw RealmError.letterNotFound
            }
            
            try! realm.write {
                letter.status = .temporary
            }
        }
    }
    
    func deleteLetter(petId: String, letterId: String) throws {
        let petObjId = petId.toObjectId()
        
        guard let pet: Pet = repository.findById(id: petObjId) else {
            throw RealmError.petNotFound
        }
        
        try! realm.write {
            for letter in pet.letters {
                if letter.id == letterId {
                    repository.delete(letter)
                    return
                }
            }
            throw RealmError.letterNotFound
        }
    }
    
    func updateLetter(petId: String, dto: LetterUpdateDto) throws {
        let petObjId = petId.toObjectId()
        
        guard let pet: Pet = repository.findById(id: petObjId) else {
            throw RealmError.petNotFound
        }
        
        try! realm.write {
            guard let letter = pet.letters.filter { $0.id == dto.id }.first else{
                throw RealmError.letterNotFound
            }
            
            switch letter.status {
            case .sent: throw RealmError.letterAlreadySent
            case .saved: throw RealmError.letterAlreadySaved
            case .temporary:
                repository.update(dto.toLetter(letter: letter, saveImage: imageManager.saveImage))
            }
        }
    }
    
    func send(_ id: String) throws {
        let petId = id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        try! realm.write {
            pet.letters.where { $0.status == .saved }
                .forEach { $0.status = .sent }
            
            pet.flowerLogs.where { $0.status == .unsent }
                .forEach { $0.status = .sent }
        }
    }
    
    func findUnsentLetters(_ id: String) throws -> [LetterResultDto] {
        let petId = id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        return pet.letters
            .where { $0.status != .sent }
            .sorted(byKeyPath: "createdAt", ascending: false)
            .sorted {
                if $0.status == .saved { return true }
                else if $1.status == .saved { return false }
                return true
            }
            .map { LetterResultDto.of($0) }
    }
    
    // TODO: sorted refactor
    func findSentLetters(_ id: String, _ selected: String) throws -> [LetterResultDto] {
        let petId = id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        var selectedDate: Date
        do {
            selectedDate = try DateConverter.stringToDate(selected, .yearMonthKr)
        } catch {
            throw RealmError.illegalDateArgument
        }
        
        guard let next = Date.getNextMonth(selectedDate) else {
            throw RealmError.illegalDateArgument
        }
        return pet.letters
            .where { $0.status == .sent }
            .where { $0.createdAt >= selectedDate && $0.createdAt < next }
            .sorted(byKeyPath: "createdAt", ascending: false)
            .map { LetterResultDto.of($0) }
    }

    func findAllFlowers() -> [FlowerResultDto] {
        let results: Results<Flower> = repository.findAll()
        return results.toArray()
            .map { FlowerResultDto.of($0) }
    }
    
    func chooseFlower(petId: String, flowerId: String) throws {
        let petId = petId.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        let flowerId = flowerId.toObjectId()
        guard let flower: Flower = repository.findById(id: flowerId) else {
            throw RealmError.flowerNotFound
        }
        
        // 남아 있는 log가 있으면 있는 log를 바꾼다.
        let results: Results<FlowerLog> = repository.findAll().where { $0.status == .unsent }
        if !results.isEmpty {
            updateFlower(flower: flower, flowerLog: results[0])
        } else {
            // 남아 있는 log가 없으면 새 log 생성
            let flowerLog = FlowerLog(flower: flower)
            try! realm.write {
                pet.flowerLogs.append(flowerLog)
            }
        }
    }
    
    func getMainView(_ id: String) throws -> MainViewResultDto {
        let petId = id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        guard let word: Words = repository.findRandomOne() else {
            throw RealmError.wordNotFound
        }
        
        let todayFlowerLog = pet.flowerLogs
            .where { $0.createdAt > Date.startOfToday() }
            .sorted(byKeyPath: "createdAt", ascending: false)
        
        let flowerLog = todayFlowerLog
            .where { $0.status == .unsent }
            .first
        
        let permitted = todayFlowerLog.count > 0 ? true : false
        
        let letterCount = pet.letters
            .where { $0.status == .saved }
            .count
        
        return MainViewResultDto(flowerLog, letterCount, permitted, word)
    }
    
    func getHeavenView(_ id: String) throws -> HeavenViewResultDto {
        let petId = id.toObjectId()
        guard let pet: Pet = repository.findById(id: petId) else {
            throw RealmError.petNotFound
        }
        
        let flowerLogs = pet.flowerLogs
            .where { $0.status == .sent }
            .sorted(byKeyPath: "createdAt", ascending: false)
        return HeavenViewResultDto.of(flowerLogs.toArray())
    }
    
    private func updateFlower(flower: Flower, flowerLog: FlowerLog) {
        try! realm.write {
            flowerLog.flower = flower
        }
    }
    
    init(_ realm: Realm, _ repository: RealmRepository) {
        self.realm = realm
        self.repository = repository
    }
}
