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
    var followers: [User]?
    var following: [User]?
    var repos: [Repo]?
//    var joinDate: Date?
//    var biography: String?
//    var email: String?
//    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case username       = "login"
        case imageURL       = "avatar_url"
        case followers      = "followers_url"
        case following      = "following_url"
        case repos          = "repos_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        followers = try container.decode([User].self, forKey: .followers)
        following = try container.decode([User].self, forKey: .following)
        repos = try container.decode([Repo].self, forKey: .repos)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }

}
