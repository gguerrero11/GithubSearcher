//
//  User.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int?
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
        case id             = "id"
        case username       = "login"
        case imageURL       = "avatar_url"
        case followersURL   = "followers_url"
        case followingURL   = "following_url"
        case reposURL       = "repos_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        followersURL = try container.decode(String.self, forKey: .followersURL)
        followingURL = try container.decode(String.self, forKey: .followingURL)
        reposURL = try container.decode(String.self, forKey: .reposURL)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
