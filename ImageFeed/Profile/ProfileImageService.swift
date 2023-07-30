//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 16.07.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var fetchProfileImageTask: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let tokenStorage: OAuth2TokenStorage
    private let urlSession = URLSession.shared
    
    private init() {
        tokenStorage = OAuth2TokenStorage.shared
    }
    
    struct UserResult: Codable {
        let profile_image: ProfileImage
    }
    
    struct ProfileImage: Codable {
        let large: String
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        fetchProfileImageTask?.cancel()
        
        guard let token = tokenStorage.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        let baseURL = URL(string: "https://api.unsplash.com/")!
        let url = baseURL.appendingPathComponent("/users/\(userName)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileImageTask = urlSession.objectTask(for: request) { [ weak self ] (response:Result<UserResult, Error>) in
            defer { self?.fetchProfileImageTask = nil }
            
            switch response{
            case .success(let result):
                completion(.success(result.profile_image.large))
                NotificationCenter.default.post(name:ProfileImageService.DidChangeNotification,
                                                object:self,
                                                userInfo: ["URL": result.profile_image.large])
                self?.avatarURL = result.profile_image.large
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        fetchProfileImageTask?.resume()
    }
}
