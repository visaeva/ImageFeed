//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 01.08.2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var currentTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    private var page: Int = 1
    
    private init() {}
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard currentTask == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        page = nextPage
        
        guard let authToken = OAuth2TokenStorage.shared.token else {
            assertionFailure("Failed to make HTTP request")
            return
        }
        
        guard let request = makeRequest(authToken: authToken, page: nextPage) else {
            return
        }
        
        let task = urlSession.objectTask(for: request) { [ weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    if self.lastLoadedPage == nil {
                        self.lastLoadedPage = 1
                    } else {
                        self.lastLoadedPage! += 1
                    }
                    let newPhotos = photoResults.map { Photo($0, date: self.dateFormatter) }
                    self.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike:Bool, _ completion: @escaping(Result<Void, Error>)->Void) {
        if currentTask != nil {
            currentTask?.cancel()
        }
        
        guard let request = likeRequest(photoId: photoId, isLike: isLike) else {
            return
        }
        let task = urlSession.objectTask(for: request) { (result: Result<PhotoLiked, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                        let photo = self.photos[index]
                        
                        let newPhotoResult = PhotoResult(id: photo.id,
                                                         width: Int(photo.size.width),
                                                         height: Int(photo.size.height),
                                                         createdAt: photo.createdAt?.description,
                                                         description: photo.welcomeDescription,
                                                         urls: UrlsResult(full: photo.largeImageURL, regular: photo.regularImageURL,
                                                                          small: photo.smallImageURL, thumb: photo.thumbImageURL
                                                                         ),
                                                         likedByUser: !photo.isLiked)
                        
                        let newPhoto = Photo(newPhotoResult, date: self.dateFormatter)
                        
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                case .failure(let error):
                    assertionFailure("like error: \(error)")
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    private func makeRequest(authToken: String, page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
            assertionFailure("Error with URL")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        guard let url = urlComponents.url else {
            assertionFailure("Error with URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func likeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        let baseURL = "https://api.unsplash.com"
        let likeURL = "\(baseURL)/photos/\(photoId)/like"
        
        guard let url = URL(string: likeURL) else {
            assertionFailure("Error with URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        guard let authToken = OAuth2TokenStorage.shared.token else {
            return nil
        }
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
