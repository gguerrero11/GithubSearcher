//
//  UsersManager.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation
import UIKit

class UsersManager {
    var users = [User]()
    var usersDownloadCallback: (()->Void)?
    
    let usersUrl = "https://api.github.com/users"
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        if let url = URL(string: usersUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                self.handleData(data: data)
            }.resume()
        }
    }
    
    func handleData(data: Data?) {
        if let data = data {
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
                handleJSONString(jsonString)
            }
        }
    }
    
    func handleJSONString(_ jsonString: String) {
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let response = try JSONDecoder().decode(Response.self, from: jsonData)
//            self.users = response.feed.results
            if let callback = self.usersDownloadCallback {
                callback()
            }
        } catch {
            print(error)
        }
    }
    
    /// Cache the image. The return is an optional, if it returns nil, the image was not found.
    ///
    /// By storing the image into the file manager, we don't have to store images on UserDefaults (as we shouldn't).
    /// This allows us to just save the path of the image (stored on the device) into UserDefaults to use
    ///
    /// - Parameter image: The image to be cached
    /// - Parameter forPath: The key to cache the image. In this case, the URL of the image.
    
    static func cacheImage(image: UIImage, forKey key: String) {
        let imageData = image.jpegData(compressionQuality: 1)
        let relativePath = "image_\(Date.timeIntervalSinceReferenceDate).jpg"
        let cachePath = UsersManager.documentsPathForFileName(name: relativePath)
        let url = URL(fileURLWithPath: cachePath)
        do {
            try imageData?.write(to: url, options: .atomic)
            UserDefaults.standard.set(relativePath, forKey: key)
            UserDefaults.standard.synchronize()
        } catch {
            print("error caching")
        }
    }
    
    /// Finds the image in the cache. The return is an optional, if it returns nil, the image was not found.
    ///
    /// By using the key (in this case the web URL of the image), we can see if there is a path to the local drive
    /// of this image. If it is present then it will go look for the image in FileManager and return it.
    ///
    /// - Parameter key: The key to get the image. In this case, the URL
    /// - Returns: The image
    
    static func getImage(forKey key: String) -> UIImage? {
        var image: UIImage?
        let possibleOldImagePath = UserDefaults.standard.object(forKey: key) as? String
        if let oldImagePath = possibleOldImagePath {
            let oldFullPath = UsersManager.documentsPathForFileName(name: oldImagePath)
            let url = URL(fileURLWithPath: oldFullPath)
            do {
                let oldImageData = try Data(contentsOf: url)
                image = UIImage(data: oldImageData)
            } catch {
                print("error getting cached Image")
            }
        }
        return image
    }
    
    /// Gets the path for the store imaged directory
    ///
    /// - Parameter name: The key to image.
    /// - Returns: The relative path to the directory
    static func documentsPathForFileName(name: String) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let fullPath = path.appendingPathComponent(name)
        return fullPath.relativePath
    }
    
}

struct Response: Codable {
//    var feed: Feed
//
//    struct Feed: Codable {
//        var results: [Users]
//        var title: String?
//    }
}
