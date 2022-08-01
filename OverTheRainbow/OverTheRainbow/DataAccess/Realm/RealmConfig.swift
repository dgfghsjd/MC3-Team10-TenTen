//
//  RealmProvider.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//
// swiftlint:disable force_try

import Foundation
import RealmSwift

// TODO: getService를 실질적으로 한 번만 호출하도록 변경
class RealmConfig: DataAccessConfig {
    public static let config = RealmConfig()
    private static var didSet: Bool = false
    
    private(set) var realm: Realm
    
    private func getRepository() -> RealmRepository {
        return RealmRepository(realm: self.realm)
    }

    public func getService() -> DataAccessService {
        return RealmService(realm, self.getRepository())
    }
    
    // TODO: init 메서드 리팩토링
    private init() {
        let appName = "over-the-rainbow"
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(appName)
        config.fileURL!.appendPathExtension("realm")
        realm = try! Realm(configuration: config)
        
        if !UserDefaults.standard.bool(forKey: "didSet") {
            try! realm.write {
                RealmPreset.Flowers.forEach { name, meaning, imgUrl in
                    realm.add(Flower(name, meaning, imgUrl))
                }

                RealmPreset.Words.forEach { content in
                    realm.add(Words(content))
                }
            }
            UserDefaults.standard.set(true, forKey: "didSet")
        }
        print("Realm FilePath: \t\(realm.configuration.fileURL!)")
    }
}
