//
//  ProfileViewPresenterSpy.swift
//  ProfileViewTest
//
//  Created by Victoria Isaeva on 14.08.2023.
//

import Foundation
import ImageFeed

final class ProfileViewPresenterSpy: ImageFeed.ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var isUpdateAvatarCalled = false
    var isUpdateProfileCalled = false
    var isViewDidLoadCalled: Bool = false
    
    var receivedAvatarURL: URL?
    
    func updateAvatar() {
        isUpdateAvatarCalled = true
    }
    
    func updateAvatar(url: URL) {
        isUpdateAvatarCalled = true
        receivedAvatarURL = url
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        isUpdateProfileCalled = true
    }
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
}
