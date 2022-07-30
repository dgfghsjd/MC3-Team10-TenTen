//
//  ImageType.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/27.
//

import Foundation

enum ImageType: String {
    case jpeg, png
    
    var value: String {
        switch self {
        case .jpeg:
            return ".jpeg"
        case .png:
            return ".png"
        }
    }
}
