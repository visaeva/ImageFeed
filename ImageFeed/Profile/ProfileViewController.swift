//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 10.06.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var userNameLabel = UILabel()
    private var profileImage = UIImage(named:"Avatar")
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        updateProfileDetails(profile: profileService.profile)
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [ weak self ] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private let exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "exit")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func updateAvatar() {
        guard let profileImage = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImage)
        else { return }
        let cache = ImageCache.default
        cache.clearDiskCache()
        
        avatarImageView.kf.setImage(with: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [.processor(processor), .transition(.fade(1))])
    }
    
    func updateProfileDetails(profile: Profile?) {
        if let profile = profile {
            nameLabel.text = profile.name
            userNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            print("Error profile not found")
        }
    }
    
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
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            OAuth2TokenStorage.shared.clean()
            WebViewViewController.clean()
            ImagesListCell.clean()
            
            guard let window = UIApplication.shared.windows.first else {
                fatalError("invalid configuration")
            }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}
