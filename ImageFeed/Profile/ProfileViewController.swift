//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 10.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor(named: "YP Black")
        
        blackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blackView)
        
        NSLayoutConstraint.activate([
            blackView.topAnchor.constraint(equalTo: view.topAnchor),
            blackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let profileImage = UIImage(named: "Avatar")
        let avatarImageView = UIImageView(image: profileImage)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:32)
            
        ])
        
        let exitButton = UIButton.systemButton(with: UIImage(named: "exit")!, target: self, action: #selector(self.didTapBackButton))
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            exitButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.leadingAnchor)
        ])
        
        let nameLabel = UILabel()
        let descriptionLabel = UILabel()
        let userNameLabel = UILabel()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        nameLabel.text = "Екатерина Новикова"
        descriptionLabel.text = "Hello, World!"
        userNameLabel.text = "@ekaterina_now"
        
        nameLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.textColor = UIColor(named: "YP White")
        userNameLabel.textColor = UIColor(named: "YP Gray")
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        userNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    @objc
    
    private  func didTapBackButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
