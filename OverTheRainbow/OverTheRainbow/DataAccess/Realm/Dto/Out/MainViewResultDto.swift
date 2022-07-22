//
//  MainViewResultDto.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/21.
//

import Foundation

struct MainViewResultDto {
    let flower: FlowerResultDto?
    let letterCount: Int
    
    init(_ flowerLog: FlowerLog?, _ letterCount: Int) {
        self.letterCount = letterCount
        if let flowerLog = flowerLog {
            self.flower = FlowerResultDto.of(flowerLog.flower!)
        } else {
            flower = nil
        }
    }
}
