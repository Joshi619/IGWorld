//
//  ImagePreviewCell.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import UIKit

class ImagePreviewCell: UICollectionViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    
    static let identifier = String(describing: ImagePreviewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func filltheData(_ model: ImageInfo) {
        if let url = URL(string: model.url ?? "") {
            galleryImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "no_thumbnail"), options: .refreshCached, context: nil)
        }
        playImageView.isHidden = true
    }
}
