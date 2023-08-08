//
//  CacheManager.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 06.08.2023.
//

import Foundation
import Kingfisher

final class CacheManager {
    
    static func clean() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.backgroundCleanExpiredDiskCache()
        cache.cleanExpiredMemoryCache()
        cache.clearCache()
    }
}
