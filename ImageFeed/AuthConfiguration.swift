//
//  Constants.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 03.07.2023.
//

import Foundation
let AccessKey = "173GczLPLjlDADGY4F4UvmR6L6AhuV7bEGg6f8wCABA"
let SecretKey = "-r5iDrSN3H_Xwd-QDbMM6-DTDvWwBGh5Sf6IIhqF_aE"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            authURLString: UnsplashAuthorizeURLString,
            defaultBaseURL: DefaultBaseURL)
        
        
    }
}
