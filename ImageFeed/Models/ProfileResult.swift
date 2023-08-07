//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 06.08.2023.
//

import Foundation

struct ProfileResult: Codable {
    var userName: String?
    var firstName: String?
    var lastName: String?
    var bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
