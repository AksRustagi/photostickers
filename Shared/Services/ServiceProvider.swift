//
//  ServiceProvider.swift
//  PhotoStickers
//
//  Created by Jochen Pfeiffer on 09/02/2017.
//  Copyright © 2017 Jochen Pfeiffer. All rights reserved.
//

import Foundation

protocol ServiceProviderType: class {
    var imageStoreService: ImageStoreServiceType { get }
    var realmService: RealmServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    var imageStoreService: ImageStoreServiceType {
        let url = AppGroup.documentsURL
        return ImageStoreService(provider: self, url: url)
    }

    var realmService: RealmServiceType {
        let url = AppGroup.documentsURL?.appendingPathComponent("photo-stickers.realm")
        return RealmService(provider: self, url: url)
    }
}
