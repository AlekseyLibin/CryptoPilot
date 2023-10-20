//
//  LocalFileManager.swift
//  CryptoPilot
//
//  Created by Aleksey Libin on 13.10.2023.
//

import Foundation
import SwiftUI

final class LocalFileManager {
  static let instance = LocalFileManager()
  private init() { }
  
  func saveImage(_ image: UIImage, imageName: String, folderName: String) {
    //create a folder
    createFolderIfNeeded(folderName: folderName)
    
    // get path for an image
    guard
      let data = image.pngData(),
      let url = getURLFor(image: imageName, in: folderName)
    else { return }
    
    // save the image to path
    do {
      try data.write(to: url)
    } catch {
      print("Error saving image: \(error.localizedDescription)")
    }
  }
  
  func getImage(_ imageName: String, folderName: String) -> UIImage? {
    guard
      let url = getURLFor(image: imageName, in: folderName),
      FileManager.default.fileExists(atPath: url.path) else { return nil }
    
    return UIImage(contentsOfFile: url.path)
  }
  
  private func createFolderIfNeeded(folderName: String) {
    guard let url = getURLFor(folder: folderName) else { return }
    if !FileManager.default.fileExists(atPath: url.path) {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
      } catch {
        print("Error creating directory. Folder name: \(folderName). \(error.localizedDescription)")
      }
    }
  }
  
  private func getURLFor(folder name: String) -> URL? {
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    return url?.appendingPathComponent(name)
  }
  
  private func getURLFor(image name: String, in folderName: String) -> URL? {
    let folderURL = getURLFor(folder: folderName)
    return folderURL?.appendingPathComponent(name + ".png")
  }
}
