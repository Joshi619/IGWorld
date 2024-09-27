//
//  HomeViewController.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import UIKit

class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    
    // CollectionView setup
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        viewModel.delegate = self
        
        // Initialize and configure the collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // Size for each item
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        // Register custom cell
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.identifier)
        
        // Add collection view to the view hierarchy
        view.addSubview(collectionView)
        
        viewModel.myGallaryAPI()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Number of items (images) in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageslist.count
    }
    
    // Provide the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as? GalleryCell else { return UICollectionViewCell() }
        if let url = viewModel.imageslist[indexPath.row].thumbnailURL {
            cell.imageView.sd_setImage(with: URL(string: url)) // Load the image from assets
        }
        return cell
    }
}

// MARK: - Other Controller
extension HomeViewController {
    private func openImagePreview(indexPath: IndexPath) { // open the detail screen.
//        let imagePreview = ALImageGalleryViewController(images: [previewView.image ?? UIImage()], delegate: self)
//        imagePreview.modalTransitionStyle = .crossDissolve
//        imagePreview.modalPresentationStyle = .fullScreen
//        self.present(imagePreview, animated: true, completion: nil)
        
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func gallaryAPISucess() {
        collectionView.reloadData()
    }
    
    func gallaryAPIFailure(_ message: String) {
        Alert.alert(message: message, self)
    }
}
