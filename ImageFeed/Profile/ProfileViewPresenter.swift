//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 09.08.2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [ weak self ] _ in
                guard let self = self else { return }
            }
    }
    
    func updateAvatar() {
        guard let avatarURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: avatarURL) else {
            return
        }
        view?.updateAvatar(url: url)
    }
    
    func updateProfileDetails(profile: Profile?) {
        if let profile = profile {
            if let name = profile.name, let loginName = profile.loginName, let bio = profile.bio {
                view?.nameLabel(name)
                view?.userNameLabel(loginName)
                view?.descriptionLabel(bio)
            } else {
                print("Error profile not found")
            }
        }
    }
}
