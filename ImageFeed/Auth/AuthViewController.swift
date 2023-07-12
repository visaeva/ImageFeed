//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 04.07.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let webViewIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(webViewIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let authToken):
                OAuth2TokenStorage.shared.token = authToken
            case .failure(let error):
                print("Ошибка получения токена: \(error)")
            }
            DispatchQueue.main.async {
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
