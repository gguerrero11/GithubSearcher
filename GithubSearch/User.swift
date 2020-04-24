//
//  User.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation

struct User: Codable {
    var username: String?
    var imageURL: String?
    var reposURL: String?
    var followersURL: String?
    var followingURL: String?
//    var joinDate: Date?
//    var biography: String?
//    var email: String?
//    var location: String?
    
    // Transient Vars
    var followers: [User]?
    var following: [User]?
    var repos: [Repo]?
    
    enum CodingKeys: String, CodingKey {
        case username       = "login"
        case imageURL       = "avatar_url"
        case followersURL   = "followers_url"
        case followingURL   = "following_url"
        case reposURL       = "repos_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        followersURL = try container.decode(String.self, forKey: .followersURL)
        followingURL = try container.decode(String.self, forKey: .followingURL)
        reposURL = try container.decode(String.self, forKey: .reposURL)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
