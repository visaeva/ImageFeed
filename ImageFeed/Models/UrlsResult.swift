//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 06.08.2023.
//

import Foundation

struct UrlsResult: Decodable {
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
