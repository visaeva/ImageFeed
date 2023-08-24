//
//  CacheManager.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 06.08.2023.
//

import Foundation
import Kingfisher
import WebKit

final class CacheManager {
    
    static func clean() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.backgroundCleanExpiredDiskCache()
        cache.cleanExpiredMemoryCache()
        cache.clearCache()
    }
    
    static func cleanCache() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

