//
//  HomeViewController.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import UIKit
import SDWebImage
class HomeViewController: BaseVC {
    let viewModel = HomeViewModel()

    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func setupUI() {
        self.title = LocalizedString.appTitle.localized
        viewModel.delegate = self
        
        // Initialize and configure the collection view
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100) // Size for each item
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 5
//
        guard Reachability.isConnectedToNetwork() else {
            Alert.alert(message: AppConstant.lostConnectionMessage, self)
            return
        }
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.backgroundColor = .white
        
        // Register custom cell
        gridCollectionView.register(UINib(nibName: GalleryCell.identifier, bundle: nil), forCellWithReuseIdentifier: GalleryCell.identifier)
        gridCollectionView.reloadData()
        viewModel.myGallaryAPI()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageslist.count
    }
    
    // Provide the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as? GalleryCell else { return UICollectionViewCell() }
        if let url = viewModel.imageslist[indexPath.row].thumbnailURL {
            cell.pictureView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "no_thumbnail"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: gridCollectionView.frame.width/4, height: gridCollectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openImagePreview(indexPath: indexPath)
    }
}

// MARK: - Other Controller
extension HomeViewController {
    private func openImagePreview(indexPath: IndexPath) { // open the detail screen.
        let detailVC = GalleryPreviewVC.instantiate(fromAppStoryboard: .Main)
        detailVC.viewModel = viewModel
        detailVC.selectedIndex = indexPath.item
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func gallaryAPISucess() {
        gridCollectionView.reloadData()
    }
    
    func gallaryAPIFailure(_ message: String) {
        Alert.alert(message: message, self)
    }
}
