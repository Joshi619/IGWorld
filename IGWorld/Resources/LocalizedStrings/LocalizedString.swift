//
//  LocalizedString.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation

enum LocalizedString : String {

    case appTitle = "IG World"
    case areYouSureWantToUpload = "Are you sure want to upload?"
    case yes = "Yes"
    case no = "No"
    case Okay = "Okay"
    case Ok = "Ok"
    case cancel = "Cancel"
    case sureWantToLogOut = "Are you sure want to Logout?"
    case areYouSureWantToDelete = "Are you sure want to delete?"
    case deleting = "Deleting...."
    case pleaseSelectAtleastOne = "Please select atleast one."
    case downloadingCompleted = "Downloading Completed"
    case chooseOptions = "Choose a options"
    case all = "All"
    case onlyPhotos = "Only Photos"
    case onlyVideos = "Only Videos"
    case videos = "Videos"
    case photos = "Photos"
    case gallery = "Gallery"
    case selectAll = "Select all"
    case InDevelopment = "In development!"
    case componentIsnotReady = "This component isn't ready"
    case edit = "Edit"
    case copied = "Copied"
    case help = "Help"
    case takeImageFromCamera = "Photo from Camera"
    case takeVideoFromCamera = "Video from Camera"
    case takeFromPhotos = "Take from Photos"
    case takeFromVideos = "Take from Videos"
    case warning = "Warning"
    case somethingWentWrong = "Something went wrong."
    case dontHaveCamera = "You don't have camera"
    case noPhotoAndVideoYet = "No Photos or Videos yet."
    case noPhotoyet = "No Photos yet."
    case noVideosyet = "No Videos yet."
}

extension LocalizedString {
    var localized : String {
        return self.rawValue.localized
    }
}
