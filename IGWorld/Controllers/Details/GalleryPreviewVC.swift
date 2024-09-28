//
//  GalleryPreviewVC.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import UIKit

class GalleryPreviewVC: BaseVC {
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var previewCollectionView: UICollectionView!
    
    var viewModel = HomeViewModel()
    
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewCollectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    /// Configure UI.
    func setupUI() {
        self.title = viewModel.imageslist[selectedIndex].title
        //        addrightSelectButton()
        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        
        listCollectionView.register(UINib(nibName: ImagePreviewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImagePreviewCell.identifier)
        previewCollectionView.register(UINib(nibName: ImagePreviewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImagePreviewCell.identifier)
        previewCollectionView.reloadData()
        
    }
    
    private func addrightSelectButton() {
        let edit = UIButton()
        edit.setTitle(LocalizedString.edit.localized, for: .normal)
        edit.setTitleColor(AppColors.babiesPink, for: .normal)
        edit.titleLabel?.font = .systemFont(ofSize: 16.0)
        edit.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        edit.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = edit
        self.navigationItem.rightBarButtonItem = item1
    }
    
}


// MARK: - @IBAction's & @Objc Methods
extension GalleryPreviewVC {
    @IBAction func shareAction(_ sender: UIButton) {
        openActivityIndicator()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        //        Alert.notReadyAlert(self)
        Alert.notReadyAlert(self)
    }
    
    @objc func editAction() {
        Alert.notReadyAlert(self)
    }
}

// MARK: - Logic's
extension GalleryPreviewVC {
    func loadURLForActivityShare() {
        if let url = URL(string: viewModel.imageslist[selectedIndex].url ?? "") {
            Alert.showProgressHud()
            url.downLoadURL { [weak self] downloadURL, downloadData in
                guard let weak = self else { return }
                
                DispatchQueue.main.async {
                    Alert.hideProgressHud()
                    if let `downloadURL` = downloadURL {
                        //                        weak.openActivityIndicator(url: downloadURL)
                    }
                }
            }
        }
    }
    
    // MARK: - Sharing activity
    fileprivate func openActivityIndicator() {
        var textToShare = [Any]()
        guard let imgURL = NSURL(string: viewModel.imageslist[self.selectedIndex].url ?? "") else {
            Alert.alert(message: LocalizedString.somethingWentWrong.localized, self)
            return
        }
        ImageLoader.shared.load(imgURL, index: 0) { image, Index in
            if let image = image, let delegate = UIApplication.shared.delegate as? AppDelegate {
                if delegate.server == .production {
                    textToShare = [ "Check out my imagery shared from IGWorld \n \(imgURL)", image]
                } else {
                    textToShare = [ "Check out my imagery shared from IGWorld \n \(imgURL)", image]
                }
            }
        }
        
        
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        
        
        
        // New Excluded Activities Code
        if #available(iOS 9.0, *) {
            activityVC.excludedActivityTypes = [ .addToReadingList, .assignToContact, .copyToPasteboard, .openInIBooks, .postToTencentWeibo, .postToVimeo, .postToWeibo, .assignToContact, .openInIBooks, .markupAsPDF,.saveToCameraRoll]
        } else {
            activityVC.excludedActivityTypes = [ .addToReadingList, .assignToContact, .copyToPasteboard, .openInIBooks, .postToTencentWeibo, .postToVimeo, .postToWeibo, .assignToContact, .openInIBooks, .markupAsPDF,.saveToCameraRoll]
        }
        self.present(activityVC, animated: true)
    }
}

// MARK: -
extension GalleryPreviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageslist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePreviewCell.identifier, for: indexPath) as? ImagePreviewCell else { return UICollectionViewCell() }
        if let url = collectionView == self.previewCollectionView ? viewModel.imageslist[indexPath.item].url : viewModel.imageslist[indexPath.item].thumbnailURL {
            cell.galleryImageView.setImageFrom(url: url, index: indexPath.item) { image, index in
                let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ImagePreviewCell
                cell?.galleryImageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.previewCollectionView {
            return CGSize(width: self.previewCollectionView.frame.width, height: self.previewCollectionView.frame.height)
        }
        return CGSize(width: self.previewCollectionView.frame.width/4, height:  self.previewCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.listCollectionView {
            // handle click event
            selectedIndex = indexPath.item
            self.title = viewModel.imageslist[indexPath.item].title
            previewCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            selectedIndex = indexPath.item
            self.title = viewModel.imageslist[indexPath.item].title
            clickOnImage(index: selectedIndex)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == previewCollectionView {
            for cell in previewCollectionView.visibleCells {
                if let row = previewCollectionView.indexPath(for: cell)?.item {
                    selectedIndex = row
                    self.title = viewModel.imageslist[row].title
                    listCollectionView.scrollToItem(at: IndexPath(item: row, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
}

// MARK: - Delegate's
extension GalleryPreviewVC: HomeViewModelDelegate {
    func clickOnImage(index: Int) {
        if let url = URL(string: viewModel.imageslist[index].url ?? "") {
            ImageLoader.shared.load(url as NSURL, index: 0) { image, index in
                let imagePreview = ALImageGalleryViewController(images: [image ?? UIImage()])
                imagePreview.modalTransitionStyle = .crossDissolve
                imagePreview.modalPresentationStyle = .fullScreen
                self.present(imagePreview, animated: true, completion: nil)
            }
        }
    }
}

extension GalleryPreviewVC: ALImageGalleryDelegate {
    func galleryDidReceiveTap(_ imageGallery: ALImageGalleryViewController) {
        
    }
    
    func galleryDidReceiveDoubleTap(_ imageGallery: ALImageGalleryViewController) {
        imageGallery.dismiss(animated: true)
    }
    
    func galleryDidDismiss(_ imageGallery: ALImageGalleryViewController) {
        
    }
    
    func galleryImageDragged(_ imageGallery: ALImageGalleryViewController) {
        
    }
    
    
}
