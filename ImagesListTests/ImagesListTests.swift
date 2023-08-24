//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Victoria Isaeva on 14.08.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testImagesViewControllerCallsViewDidLoad() {
        //Given
        let imageListService = ImagesListService()
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLike () {
        //Given
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //When
        view.changeLike()
        
        //Then
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
    
    func testLoadPhotoToTable() {
        //Given
        let tableView = UITableView()
        let tableCell = UITableViewCell()
        let indexPath: IndexPath = IndexPath(row: 2, section: 2)
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        
        //When
        view.tableView(tableView, willDisplay: tableCell, forRowAt: indexPath)
        
        //Then
        XCTAssertTrue(presenter.didFetchPhotosCalled)
    }
}
