//
//  ProfileViewControllerSpy.swift
//  ProfileViewTest
//
//  Created by Victoria Isaeva on 14.08.2023.
//

import Foundation
import ImageFeed

class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    var isUpdateAvatarCalled = false
    var updatedAvatarURL: URL?
    
    var isNameLabelCalled = false
    var updatedName: String?
    
    var isUserNameLabelCalled = false
    var updatedUserName: String?
    
    var isDescriptionLabelCalled = false
    var updatedDescription: String?
    
    func updateAvatar(url: URL) {
        isUpdateAvatarCalled = true
        updatedAvatarURL = url
    }
    
    func nameLabel(_ name: String) {
        isNameLabelCalled = true
        updatedName = name
    }
    
    func userNameLabel(_ userName: String) {
        isUserNameLabelCalled = true
        updatedUserName = userName
    }
    
    func descriptionLabel(_ description: String) {
        isDescriptionLabelCalled = true
        updatedDescription = description
    }
}


