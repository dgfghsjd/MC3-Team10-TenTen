//
//  DataAccessProvider.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//

import Foundation
import RealmSwift
import CoreData

protocol DataAccessProvider {
    // TODO: Pet 생성
    func addPet(_ inputDto: PetInputDto) -> Void
    
    // TODO: Pet 정보 가져오기
    func findPet(id: String) throws -> PetResultDto
    
    // TODO: Pet List 가져오기
    func findAllPet() -> Array<PetResultDto>
    
    // TODO: 편지 생성하기 (임시저장 상태)
    func addLetter(_ inputDto: LetterInputDto) throws -> Void
    
    // TODO: 편지 저장하기 (저장 상태로 변경)
    func saveLetters(_ ids: String...) throws -> Void
    
    // TODO: 편지 임시저장 상태로 변경하기
    func unsaveLetters(_ ids: String...) throws -> Void
    
    // TODO: 보낼 예정인 편지들 가져오기
    func findUnsentLetters(_ id: String) throws -> Array<LetterResultDto>
    
    // TODO: 보낸 편지 List 가져오기 (보냄 상태 편지 가져오기 + 월별로)
    
    
    // TODO: 꽃 리스트 보여주기 (선택할 수 있도록)
    
    // TODO: 꽃 선택하기 (로그 생성하고 일단 unsent 상태로)
    
    // TODO: 보내기 (꽃 로그와 편지 상태 -> 보냄으로 변경)
    
    // TODO: 메인 뷰 보여주기
    
}
