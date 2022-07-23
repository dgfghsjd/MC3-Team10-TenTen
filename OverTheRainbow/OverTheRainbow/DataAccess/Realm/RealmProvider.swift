//
//  RealmProvider.swift
//  OverTheRainbow
//
//  Created by Leo Bang on 2022/07/20.
//
// swiftlint:disable force_try

import Foundation
import RealmSwift

class RealmProvider {

    private let realm: Realm = try! Realm()
    
    private func getRepository() -> RealmRepository {
        return RealmRepository(realm: self.realm)
    }
    
    public func getService() -> RealmService {
        return RealmService(realm, self.getRepository())
    }
}
