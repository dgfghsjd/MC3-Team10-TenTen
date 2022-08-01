//
//  MainViewResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

struct MainViewResultDto {
    private(set) var flower: FlowerResultDto?
    private(set) var letterCount: Int
    private(set) var permitted: Bool
    private(set) var word: WordResultDto
    
    init(_ flowerLog: FlowerLog?, _ letterCount: Int, _ permitted: Bool, _ word: Words) {
        self.letterCount = letterCount
        if let flowerLog = flowerLog {
            self.flower = FlowerResultDto.of(flowerLog.flower!)
        }
        self.permitted = permitted
        self.word = WordResultDto.of(word)
    }
}
