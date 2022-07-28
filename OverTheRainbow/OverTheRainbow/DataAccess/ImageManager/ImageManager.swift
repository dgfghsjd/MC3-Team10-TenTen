//
//  ImageManager.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/27.
//swiftlint:disable force_try

import Foundation
import UIKit

// TODO: Refactor
class ImageManager {
    public static var shared: ImageManager? = ImageManager()
    
    private static let ENDPOINT = "image"
    private let fileManager: FileManager
    private let documentPath: URL
    
    public func fileNameGenerator(_ imageType: ImageType = .png) -> String {
        let ymd = DateConverter.dateToString(Date.now, .yearMonthDateHyphen)
        return ymd + UUID().uuidString + imageType.value
    }
    
    public func saveImage(_ image: UIImage) throws -> URL {
        guard let pngImage = image.pngData() else {
            throw RealmError.petNotFound
        }
        let imageUrl = documentPath.appendingPathComponent("/image/" + fileNameGenerator(.png))
        do {
            try pngImage.write(to: imageUrl)
        } catch {
            throw ImageManagerError.imageWriteError
        }
        return imageUrl
    }
    
    public func createDirectory() throws {
        let filePath = documentPath.appendingPathComponent(ImageManager.ENDPOINT)
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw ImageManagerError.directoryCreateError
            }
        }
    }
    
    private init?() {
        fileManager = FileManager.default
        guard let path = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        documentPath = path
        try! createDirectory()
    }
}
