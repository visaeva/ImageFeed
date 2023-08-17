//
//  ProfileViewTest.swift
//  ProfileViewTest
//
//  Created by Victoria Isaeva on 14.08.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTest: XCTestCase {
    
    func testProfileViewControllerUpdateAvatar() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let url = DefaultBaseURL
        
        //When
        viewController.updateAvatar(url: url)
        
        //Then
        XCTAssertTrue(viewController.isUpdateAvatarCalled)
    }
    
    func testViewControllerCallsViewDidLoad() {
        //Given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        presenter.viewDidLoad()
        
        //Then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
    
    func testProfileViewControllerUpdateProfile() {
        //Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        let profile = Profile(userName: "", name: nil, loginName: "", bio: nil)
        
        //When
        presenter.updateProfileDetails(profile: profile)
        
        //Then
        XCTAssertTrue(presenter.isUpdateProfileCalled)
    }
}
