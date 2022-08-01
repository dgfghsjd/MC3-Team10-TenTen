//
//  ImageManagerError.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/27.
//

import Foundation

enum ImageManagerError: String, Error {
    case imageWriteError
    case directoryCreateError
    case fileDeletionError
}
