//
//  StickerService.swift
//  PhotoStickers
//
//  Created by Jochen Pfeiffer on 09/02/2017.
//  Copyright © 2017 Jochen Pfeiffer. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import Log

protocol StickerServiceType {
    func fetchStickers(withPredicate predicate: NSPredicate) -> Observable<[Sticker]>
    func fetchStickers() -> Observable<[Sticker]>
    func add(_ sticker: Sticker?)
}

class StickerService: StickerServiceType {

    fileprivate let mainThreadRealm: Realm!

    init(realmURL: URL?) {
        var config = Realm.Configuration()
        config.fileURL = realmURL
        Realm.Configuration.defaultConfiguration = config

        self.mainThreadRealm = try! Realm()
    }
}

extension StickerService {
    func fetchStickers() -> Observable<[Sticker]> {
        return fetchStickers(withPredicate: NSPredicate(value: true))
    }

    func fetchStickers(withPredicate predicate: NSPredicate) -> Observable<[Sticker]> {
        let sortDescriptors = [
            SortDescriptor(keyPath: "sortOrder", ascending: true),
        ]
        let results = self.currentRealm()
            .objects(Sticker.self)
            .filter(predicate)
            .sorted(by: sortDescriptors)
        let stickers = Observable
            .array(from: results)
        return stickers
    }

    func add(_ sticker: Sticker?) {
        guard let sticker = sticker else {
            return
        }
        let realm = self.currentRealm()
        try! realm.write {
            realm.add(sticker, update: true)
        }
    }
}

extension StickerService {
    fileprivate func currentRealm() -> Realm {
        if Thread.current.isMainThread {
            return self.mainThreadRealm
        } else {
            return try! Realm()
        }
    }
}
