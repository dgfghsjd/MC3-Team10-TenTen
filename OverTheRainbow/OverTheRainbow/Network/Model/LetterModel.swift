//
//  Letter.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/25.
//

import Foundation
import UIKit


struct LetterModel: Codable {
    var title: String?
    var date: String?
    var image: String?
}

// FIXME: - 더미로 넣은 Letter 데이터
var tempLetters: [LetterModel] = [
    LetterModel(title: "c5 15번 사물함\n비밀번호: 4860\n열어보세용~", date: "오늘", image: "더미에용"),
    LetterModel(title: "c5 15번 사물함\n비밀번호: 4860\n열어보세용~", date: "22.06.03"),
]
