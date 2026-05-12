//
//  BasicCollectionViewCell.swift
//  wellSync
//
//  Created by Rishika Mittal on 11/04/26.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var uploadButton: UIButton!

    // Same callback pattern as TodayTableViewCell
    var onPhotoSourceSelected: ((UIImagePickerController.SourceType) -> Void)?
    var onTimerTapped: (() -> Void)?

    // Call this when the activity is upload-type
    func setupPhotoMenu() {
        let camera = UIAction(
            title: "Camera",
            image: UIImage(systemName: "camera")
        ) { [weak self] _ in
            self?.onPhotoSourceSelected?(.camera)
        }

        let photoLibrary = UIAction(
            title: "Photo Library",
            image: UIImage(systemName: "photo")
        ) { [weak self] _ in
            self?.onPhotoSourceSelected?(.photoLibrary)
        }

        let menu = UIMenu(title: "", children: [camera, photoLibrary])
        uploadButton.menu = menu
        uploadButton.showsMenuAsPrimaryAction = true
    }

    // Call this when the activity is timer-type
    func setupTimerButton() {
        uploadButton.menu = nil
        uploadButton.showsMenuAsPrimaryAction = false
        
        // Remove old targets to avoid multiple calls during reuse
        uploadButton.removeTarget(nil, action: nil, for: .allEvents)
        uploadButton.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
    }

    @objc private func timerTapped() {
        onTimerTapped?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        style(self)
    }
}
