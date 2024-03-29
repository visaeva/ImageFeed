//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 28.05.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        likeButton.accessibilityIdentifier = "noLike"
    }
    
    func setupCell(from photo: Photo) {
        
        let url = URL(string: photo.smallImageURL)
        cellImage.kf.indicatorType = .activity
        
        let placeholderImage = UIImage(named: "placeholderImage")
        cellImage.kf.setImage(with: url, placeholder: placeholderImage) { [ weak self ] result in
            
            switch result {
            case .success(let image):
                self?.cellImage.contentMode = .scaleAspectFill
                self?.cellImage.image = image.image
            case .failure(let error):
                print("Ошибка загрузки картинки: \(error)")
                self?.cellImage.image = UIImage(named: "placeholderImage")
            }
        }
        dateLabel.text = DateFormatterManager.shared.dateFormatter.string(from: photo.createdAt ?? Date())
        setIsLiked(isLiked: photo.isLiked)
    }
    
    func setIsLiked(isLiked:Bool) {
        let likeImage = isLiked ? UIImage(named:"like") : UIImage(named:"noLike")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func tapLikeButton(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
}
