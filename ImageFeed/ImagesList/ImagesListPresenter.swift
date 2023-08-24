//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 11.08.2023.
//

import UIKit

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func checkCompletedList(_ indexPath: IndexPath)
}

class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [ weak self ] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike, { [ weak self ] result in
            guard let self = self else { return }
            
            switch result{
            case .success(_):
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        })
    }
    
    func checkCompletedList(_ indexPath: IndexPath) {
        if imagesListService.photos.isEmpty || (indexPath.row + 1 == imagesListService.photos.count) {
            fetchPhotosNextPage()
        }
    }
}
