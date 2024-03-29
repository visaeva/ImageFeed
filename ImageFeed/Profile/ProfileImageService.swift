//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 16.07.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private var fetchProfileImageTask: URLSessionTask?
    private let tokenStorage: OAuth2TokenStorage
    private let urlSession = URLSession.shared
    
    private init() {
        tokenStorage = OAuth2TokenStorage.shared
    }
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        fetchProfileImageTask?.cancel()
        
        guard let token = tokenStorage.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        guard let baseURL = URL(string: "https://api.unsplash.com/") else {
            assertionFailure("Ошибка при создании базового URL")
            return
        }
        let url = baseURL.appendingPathComponent("/users/\(userName)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetchProfileImageTask = urlSession.objectTask(for: request) { [ weak self ] (response: Result<UserResult, Error>) in
            defer { self?.fetchProfileImageTask = nil }
            
            switch response{
            case .success(let result):
                completion(.success(result.profileImage.large))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                object: self,
                                                userInfo: ["URL": result.profileImage.large])
                self?.avatarURL = result.profileImage.large
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        fetchProfileImageTask?.resume()
    }
}
