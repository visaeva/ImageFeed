//
//  File.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 12.06.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: URL?
    private var imageDownload: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadAndShowImage(url: image)
    }
    
    func loadAndShowImage(url: URL?) {
        guard let url = url else { return }
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                self.imageDownload = imageResult.image
                
            case .failure(let error):
                print(error.localizedDescription)
                self.showError(url: url)
            }
        }
    }
    
    func compressImage(_ image: UIImage) -> UIImage {
        let targetSizeInMB: Double = 10.0
        let maxCompressionIterations = 5
        
        var compressedImage = image
        var currentSizeInMB = Double(compressedImage.pngData()?.count ?? 0) / (1024.0 * 1024.0)
        var iteration = 0
        
        while currentSizeInMB > targetSizeInMB && iteration < maxCompressionIterations {
            let compressionRatio: CGFloat = CGFloat(targetSizeInMB / currentSizeInMB)
            let newWidth = Int(compressedImage.size.width * sqrt(compressionRatio))
            let newHeight = Int(compressedImage.size.height * sqrt(compressionRatio))
            let newImageSize = CGSize(width: newWidth, height: newHeight)
            
            UIGraphicsBeginImageContext(newImageSize)
            compressedImage.draw(in: CGRect(origin: .zero, size: newImageSize))
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
                compressedImage = resizedImage
                currentSizeInMB = Double(compressedImage.pngData()?.count ?? 0) / (1024.0 * 1024.0)
            }
            UIGraphicsEndImageContext()
            iteration += 1
        }
        self.imageDownload = compressedImage
        return compressedImage
    }
    
    func showShareActivityController() {
        guard let imageDownload = imageDownload else { return }
        
        let share = UIActivityViewController(
            activityItems: [compressImage(imageDownload)],
            applicationActivities: nil
        )
        share.overrideUserInterfaceStyle = .dark
        present(share, animated: true, completion: nil)
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        showShareActivityController()
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        scrollView.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

extension SingleImageViewController {
    private func showError(url: URL) {
        let alert = UIAlertController(title: "Что-то пошло не так.", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let repeats = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self else { return }
            self.loadAndShowImage(url: url)
        }
        let cancel = UIAlertAction(title: "Не надо", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(repeats)
        
        present(alert, animated: true)
    }
}

