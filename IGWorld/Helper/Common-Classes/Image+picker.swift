//
//  Image+picker.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var docPickerController: UIDocumentPickerViewController?
    var picker = UIImagePickerController();
    var alert = UIAlertController(title:  "Choose Images or Videos", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback: ((MetaDataInfo) -> ())?;
    var pickVideoCallback: ((MetaDataInfo) -> ())?
    var pickFileCallback:  ((URL) -> ())?
    var mediaType: MetaDataType? = .image
    override init(){
        super.init()
        let cameraImageAction = UIAlertAction(title:  LocalizedString.takeImageFromCamera.localized, style: .default) {
            UIAlertAction in
            self.mediaType = .image
            self.openCamera(isVideo: false)
        }
        let cameraVideoAction = UIAlertAction(title:  LocalizedString.takeVideoFromCamera.localized, style: .default) {
            UIAlertAction in
            self.mediaType = .image
            self.openCamera(isVideo: true)
        }
        let galleryAction = UIAlertAction(title: LocalizedString.takeFromPhotos.localized, style: .default){
            UIAlertAction in
            self.mediaType = .image
            self.openGallery()
        }
        
        let videoAction = UIAlertAction(title:  LocalizedString.takeFromVideos.localized, style: .default){
            UIAlertAction in
            self.mediaType = .video
            self.openVideo()
        }
        
        let documentAction = UIAlertAction(title:  "Document", style: .default){
            UIAlertAction in
            self.mediaType = .document
            self.documentPicker()
        }
        let cancelAction = UIAlertAction(title:  LocalizedString.cancel.localized, style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.view.tintColor = AppColors.heading_color
        alert.addAction(cameraImageAction)
        alert.addAction(cameraVideoAction)
        alert.addAction(galleryAction)
        alert.addAction(videoAction)
//        alert.addAction(documentAction)
        alert.addAction(cancelAction)
    }
    
    

    func menuOption(_ button: UIButton,_ viewController: UIViewController,_ callback: @escaping ((MetaDataInfo) -> ()),_ videoCallBack: @escaping((MetaDataInfo) -> Void),_ documentPicker: @escaping((URL) -> Void)) {
        pickVideoCallback = videoCallBack
        pickImageCallback = callback
        pickFileCallback = documentPicker
        self.viewController = viewController
        let photoMenuAction = UIAction(
            title: LocalizedString.takeImageFromCamera.localized,
            image: nil
          ) { (_) in
              self.mediaType = .image
              self.openGallery()
          }
          
          let videoMenuAction = UIAction(
            title: LocalizedString.takeVideoFromCamera.localized,
            image: nil
          ) { (_) in
              self.mediaType = .video
              self.openVideo()
          }
          
          let cameraImageAction = UIAction(
            title: LocalizedString.takeFromPhotos.localized,
            image: nil
          ) { (_) in
              self.mediaType = .image
              self.openCamera(isVideo: false)
          }
        
        let cameraVideoAction = UIAction(
          title: LocalizedString.takeFromVideos.localized,
          image: nil
        ) { (_) in
            self.mediaType = .image
            self.openCamera(isVideo: true)
        }
        
        let menuActions = [cameraImageAction, cameraVideoAction, photoMenuAction, videoMenuAction]

        let addNewMenu = UIMenu(
            title: LocalizedString.chooseOptions.localized,
            children: menuActions)
        if #available(iOS 14.0, *) {
            button.menu = addNewMenu
            button.showsMenuAsPrimaryAction = true
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    func pickImage(_ viewController: UIViewController,_ callback: @escaping ((MetaDataInfo) -> ()),_ videoCallBack: @escaping((MetaDataInfo) -> Void),_ documentPicker: @escaping((URL) -> Void)) {
        pickVideoCallback = videoCallBack
        pickImageCallback = callback
        pickFileCallback = documentPicker
        self.viewController = viewController
        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - FILE PICKER
    func documentPicker(){
//        if let view = viewController?.view {
//        Alert.showAlert(LocalizedString.InDevelopment.localized, onView: view)
//            return
//        }
        DispatchQueue.main.async {
            self.docPickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeMovie as String, kUTTypeImage as String], in: .open)
            self.docPickerController!.delegate = self
            self.viewController?.present(self.docPickerController!, animated: true)
        }
    }
    
    func openCamera(isVideo: Bool){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            if isVideo {
                picker.mediaTypes = [kUTTypeMovie as String]
            }
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: LocalizedString.warning.localized, message: LocalizedString.dontHaveCamera.localized, preferredStyle: .alert)
                let action = UIAlertAction(title: LocalizedString.Ok.localized, style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    
    func openVideo() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if  let image = info[.originalImage] as? UIImage {
            if let asset = info[.imageURL] as? URL {
                let fileName = asset.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "-", with: "") + ".png"
                let info = MetaDataInfo(fileName: fileName, fileData: image.jpeg(.high)?.base64EncodedString())
                pickImageCallback?(info)
            } else {
                let info = MetaDataInfo(fileName: NSUUID().uuidString.replacingOccurrences(of: "-", with: "") + ".png", fileData: image.jpeg(.high)?.base64EncodedString())
                pickImageCallback?(info)
            }
        } else  if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            compressWithSessionStatusFunc(videoUrl)
        }
        picker.dismiss(animated: true, completion: nil)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        
    }

    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = try? Data(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                let info = MetaDataInfo(fileName: NSUUID().uuidString.replacingOccurrences(of: "-", with: "") + ".mp4", fileData: compressedData.base64EncodedString())
                self.pickVideoCallback?(info)
            case .failed:
                break
            case .cancelled:
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

//MARK: - FILE IMPORT DELEGATE
extension ImagePickerManager: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else {
            return
        }
       pickFileCallback?(url)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Media type
enum MetaDataType: String, Codable {
    case document
    case image
    case video
}


// MARK: - Upload Content
struct MetaDataInfo {
    var fileName: String?
    var fileData: String?
    
    func requestParam() -> [String: Any] {
        return ["file_name" : fileName ?? "",
                "file_data" : fileData ?? ""]
    }
}
