//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 01.08.2023.
//

import Foundation

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}


struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date
    let description: String?
    let urls: UrlsResult
 
}
struct UrlsResult: Decodable {
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var currentTask: URLSessionTask?
    private var loadLastPage:Int?
    private let urlSession = URLSession.shared
    private let dateFormatter = DateFormatter()
    
    init(){
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard currentTask == nil else {return}
        let nextPage = loadLastPage == nil ? 1 : loadLastPage! + 1
        
        guard let request = makeRequest(page: nextPage) else {
            print("Запросить фото не удалось")
            return
        }
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    if self.loadLastPage == nil {
                        self.loadLastPage = 1
                    } else {
                        self.loadLastPage!+=1
                    }
                    let newPhotos = photoResults.map { photoResults -> Photo in
                        let size = CGSize(width: photoResults.width, height: photoResults.height)
                        return Photo(id: photoResults.id, size: size, createdAt: photoResults.createdAt, welcomeDescription: photoResults.description, thumbImageURL: photoResults.urls.thumb, largeImageURL: photoResults.urls.full, isLiked: false)
                    }
                    self.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object:nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume()
        
    }
    
    private func makeRequest(page: Int) -> URLRequest? {
        guard let url = URL(string:"https://api.unsplash.com/photos") else {
            return nil
        }
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        var urlComponents = URLComponents(url:url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        guard let finalURL = urlComponents?.url else {
            return nil
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        return request
    }
}
