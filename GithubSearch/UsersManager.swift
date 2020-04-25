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
    var userSearchResults = [User]()
    var repoSearchResults = [Repo]()
    var userProfiles = [UserProfile]()
    var usersDownloadCallback: (()->Void)?
    var usersProfileDlCallback: (()->Void)?
    let usersUrl = "https://api.github.com/users"
    let isMockData = false
    
    init() {
        getUsers()
    }
    
    func getUserProfile(forUser user: User, completion: @escaping (UserProfile)->Void) {
        guard !isMockData else {
            let profile = try! JSONDecoder().decode(UserProfile.self, from: mockProfile)
            if let index = self.users.firstIndex(of: user) {
                self.users[index].userProfile = profile
                completion(profile)
            }
            return
        }
        
        guard user.userProfile == nil else { return }
        if let profURL = user.profURL, let url = URL(string: profURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let userProf: UserProfile = self.handleData(data: data) {
                    if let index = self.users.firstIndex(where: { $0.id == userProf.id }) {
                        self.users[index].userProfile = userProf
                        completion(userProf)
                    }
                }
            }.resume()
        }
    }
    
    func getRepos(forUser user: User, completion: @escaping ( ([Repo])->Void ) ) {
        guard !isMockData else {
            let repos = try! JSONDecoder().decode([Repo].self, from: mockRepo)
            if let index = self.users.firstIndex(of: user) {
                self.users[index].repos = repos
                completion(repos)
            }
            return
        }
        
        if let reposURL = user.reposURL, let url = URL(string: reposURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let xRepos: [Repo] = self.handleArrayData(data : data)
                if let index = self.users.firstIndex(of: user) {
                    self.users[index].repos = xRepos
                    completion(xRepos)
                }
            }.resume()
        }
    }
        
    func getUsers() {
        if let url = URL(string: usersUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                self.users = self.handleArrayData(data: data)
                if let callback = self.usersDownloadCallback {
                    callback()
                }
            }.resume()
        }
    }
    
    func handleArrayData<T: Decodable>(data: Data?) -> [T] {
        
        if let data = data {
            if let jsonString = String(data: data, encoding: .utf8) {
                do {
                    if let jsonData = jsonString.data(using: .utf8) {
                        let objects = try JSONDecoder().decode([T].self, from: isMockData ? mockData : jsonData)
                        return objects
                    }
                } catch {
                    print(error)
                }
            }
        }
        return []
    }
    
    func handleData<T: Decodable>(data: Data?) -> T? {
        if let data = data {
            if let jsonString = String(data: data, encoding: .utf8) {
                do {
                    if let jsonData = jsonString.data(using: .utf8) {
                        let object = try JSONDecoder().decode(T.self, from: jsonData)
                        return object
                    }
                } catch {
                    print(error)
                }
            }
        }
        return nil
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

extension UsersManager {
    func handleUserSearch(word: String, completion: @escaping (()->Void)) {
        guard word != "" else { self.userSearchResults = self.users; return }
        if let url = URL(string: "https://api.github.com/search/users?q=\(word)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let searchResult: SearchResultUser = self.handleData(data: data),
                    let items = searchResult.items {
                    self.userSearchResults = items
                    completion()
                }
            }.resume()
        }
    }
    
    func handleRepoSearch(word: String, forUser user: User, completion: @escaping (()->Void)) {
        guard let username = user.username else { return }
        if let url = URL(string: "https://api.github.com/search/users?q=\(username)+repos") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let searchResult: SearchResultRepo = self.handleData(data: data),
                    let items = searchResult.items {
                    self.repoSearchResults = items
                    completion()
                }
            }.resume()
        }
    }
}
