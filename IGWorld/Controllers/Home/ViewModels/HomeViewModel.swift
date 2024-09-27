//
//  HomeViewModel.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func gallaryAPISucess()
    func gallaryAPIFailure(_ message: String)
}
extension HomeViewModelDelegate {
    func gallaryAPISucess() { }
    func gallaryAPIFailure(_ message: String) { }
}

class HomeViewModel: NSObject {
    
    var imageslist = [ImageInfo]()
    weak var delegate: HomeViewModelDelegate?
    
    /// Get All flix gallary of user.
    /// - Parameter uid: **User's Uid**
    func myGallaryAPI() {
        ApiCall.getGallaryList(loader: true,success: { [weak self] data, status in
            guard let weak = self, let data = data else { return }
            do {
                let list = try JSONDecoder().decode([ImageInfo].self, from: data)
                weak.imageslist = list
                weak.delegate?.gallaryAPISucess()
            } catch let error as NSError {
                print(error)
            }
        }, failure: { [weak self] error, data, statusCode in
            guard let weak = self else { return }
            weak.delegate?.gallaryAPIFailure(error?.localizedDescription ?? "")
        })
        
    }
}
