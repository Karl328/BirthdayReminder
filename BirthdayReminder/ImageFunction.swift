//
//  OtherFunction.swift
//  BirthdayReminder
//
//  Created by Кирилл  Геллерт on 22.12.2021.
//

import Foundation
import UIKit

let contactImagesFolderName = "ContactImages"

func getEmptyImage() -> UIImage {
    return UIImage(named: "EmptyPhoto") ?? UIImage()
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func deleteAllImageFromContactImages() {
    let documentsDirectory = getDocumentsDirectory().appendingPathComponent(contactImagesFolderName)

    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
        for fileURL in fileURLs {
            if fileURL.pathExtension == "" {
                try FileManager.default.removeItem(at: fileURL)
            }
        }
    } catch  { print(error) }
}

func saveImageToContactImages(image: UIImage) -> String? {
    let imageName = UUID().uuidString
    let documentsDirectory = getDocumentsDirectory()
    let newCatalogPath = documentsDirectory.appendingPathComponent(contactImagesFolderName)
    if !FileManager.default.fileExists(atPath: newCatalogPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: newCatalogPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    let imagePath = newCatalogPath.appendingPathComponent(imageName)
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
        try? jpegData.write(to: imagePath)
        return imagePath.path
    }
    return nil
}

