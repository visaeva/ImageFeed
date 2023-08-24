//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 10.06.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func nameLabel(_ name: String)
    func userNameLabel(_ userName:String)
    func descriptionLabel(_ description: String)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var userNameLabel = UILabel()
    private var profileImage = UIImage(named:"Avatar")
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = ProfileViewPresenter(view: self)
        
        setupViews()
        setupConstraints()
        presenter.updateProfileDetails(profile: profileService.profile)
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        presenter.updateAvatar()
    }
    
    func nameLabel(_ name: String) {
        nameLabel.text = name
    }
    
    func userNameLabel(_ userName: String) {
        userNameLabel.text = userName
    }
    
    func descriptionLabel(_ description: String) {
        descriptionLabel.text = description
    }
    
    func updateAvatar(url: URL) {
        avatarImageView.kf.setImage(with: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [.processor(processor),
                                              .transition(.fade(1))])
        let cache = ImageCache.default
        cache.clearDiskCache()
    }
    
    private let exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "exit")
        button.accessibilityIdentifier = "exit"
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupViews() {
        avatarImageView.image = profileImage
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        userNameLabel.text = "@ekaterina_now"
        userNameLabel.textColor = UIColor(named: "YP Gray")
        userNameLabel.font = UIFont.systemFont(ofSize: 13)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            exitButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)])
    }
    
    @objc
    private  func didTapBackButton() {
        AlertManager.showExitConfirmationAlert(on: self) {
            OAuth2TokenStorage.shared.clean()
            CacheManager.cleanCache()
            CacheManager.clean()
            
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("invalid configuration")
                return
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
    }
}

