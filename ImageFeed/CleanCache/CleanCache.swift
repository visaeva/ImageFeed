//
//  CleanCache.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 06.08.2023.
//

import Foundation
import Kingfisher

class CleanCache {
    
    static func clean() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.backgroundCleanExpiredDiskCache()
        cache.cleanExpiredMemoryCache()
        cache.clearCache()
    }
}
