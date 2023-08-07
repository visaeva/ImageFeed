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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    func setupCell(from photo: Photo) {
        
        let url = URL(string: photo.smallImageURL)
        cellImage.kf.indicatorType = .activity
        
        let placeholderImage = UIImage(named: "placeholderImage")
        cellImage.kf.setImage(with: url, placeholder: placeholderImage) { result in
            
            switch result {
            case .success(let image):
                self.cellImage.contentMode = .scaleAspectFill
                self.cellImage.image = image.image
            case .failure(let error):
                print("Ошибка загрузки картинки: \(error)")
                self.cellImage.image = UIImage(named: "placeholderImage")
            }
        }
        dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        setIsLiked(isLiked: photo.isLiked)
    }
    
    func setIsLiked(isLiked:Bool) {
        let likeImage = isLiked ? UIImage(named:"like") : UIImage(named:"noLike")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    @IBAction func tapLikeButton(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
}
