//
//  UserResult.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 07.08.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
