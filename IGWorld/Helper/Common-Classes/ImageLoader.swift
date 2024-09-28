//
//  ImageLoader.swift
//  IGWorld
//
//  Created by ADITYA on 28/09/24.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private let imageLoader = ImagesCatch()
    private var uuidMap = [Int: UUID]()
    
    private init() {}
    let dispatchGroup = DispatchQueue(label: "com.mobile.imageloader")
    
    func load(_ url: NSURL, index: Int, completion: @escaping (UIImage?, Int) -> Void) {
        
        let workItem = DispatchWorkItem {
            let token = ImagesCatch.publicCache.load(url: url, completion: { image in
                defer {
                    self.uuidMap.removeValue(forKey: index)
                }
                DispatchQueue.main.async {
                    completion(image, index)
                }
            })
            if let token = token {
                self.uuidMap[index] = token
            }
        }
        dispatchGroup.sync(execute: workItem)
        
    }
    
    func cancel(for index: Int) {
        if let uuid = uuidMap[index] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: index)
        }
    }
}
