//
//  AlertManager.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 10.08.2023.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    static func showExitConfirmationAlert(on viewController: UIViewController, confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            confirmAction()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func likeAlert(with error: Error) -> UIAlertController {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.dismiss(animated: true)
        return alert
    }
}
