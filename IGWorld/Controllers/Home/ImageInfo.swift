//
//  ImageInfo.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation

struct ImageInfo: Codable {
    let albumID, id: Int?
    let title: String?
    let url, thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
