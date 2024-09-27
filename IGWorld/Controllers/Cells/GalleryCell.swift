//
//  GalleryCell.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    static let identifier = String(describing: GalleryCell.self)
    @IBOutlet weak var pictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
