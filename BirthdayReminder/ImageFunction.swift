//
//  OtherFunction.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 22.12.2021.
//

import Foundation
import UIKit

let imageFolderName = "BirthdayContactImages"

func getContactImageBy(path: String?) -> UIImage {
    if let path = path {
        let image = UIImage(contentsOfFile: path)
        return image ?? getEmptyImage()
    } else {
        return getEmptyImage()
    }
}

func deleteImagesTempFolder() {
    let fManager = FileManager.default
    let imageFolderURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                             isDirectory: true).appendingPathComponent(imageFolderName)
    
    if fManager.fileExists(atPath: imageFolderURL.path) {
        do {
            try fManager.removeItem(at: imageFolderURL)
        }
        catch {
            print(error)
        }
    }
}

func getEmptyImage() -> UIImage {
    return UIImage(named: "EmptyPhoto") ?? UIImage()
}

func saveImageToContactImages(image: UIImage) -> String? {
    let imageName = UUID().uuidString
    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                               isDirectory: true)
    let newFolderURL = tempDirectoryURL.appendingPathComponent(imageFolderName)
    do {
        try FileManager.default.createDirectory(at: newFolderURL, withIntermediateDirectories: true, attributes: [:])
        let imagePath = newFolderURL.appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try jpegData.write(to: imagePath)
            return imagePath.path
        }
    }
    catch {
        print(error)
    }
    
    return nil
}

