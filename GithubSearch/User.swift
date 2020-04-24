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
    var profURL: String?
    
    // Transient Vars
    var repos: [Repo]?
    var userProfile: UserProfile? {
        didSet {
//            print("did Set for \(userProfile)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id             = "id"
        case username       = "login"
        case imageURL       = "avatar_url"
        case reposURL       = "repos_url"
        case profURL        = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        username = try? container.decode(String.self, forKey: .username)
        imageURL = try? container.decode(String.self, forKey: .imageURL)
        reposURL = try? container.decode(String.self, forKey: .reposURL)
        profURL = try? container.decode(String.self, forKey: .profURL)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

struct UserProfile: Codable {
    var id: Int?
    var name: String?
    var joinDate: String?
    var biography: String?
    var email: String?
    var location: String?
    var followers: Int?
    var following: Int?
    var repoCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id          = "id"
        case name        = "name"
        case joinDate    = "created_at"
        case biography   = "bio"
        case email       = "email"
        case location    = "location"
        case followers   = "followers"
        case following   = "following"
        case repoCount   = "public_repos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        joinDate = try? container.decode(String.self, forKey: .joinDate)
        biography = try? container.decode(String.self, forKey: .biography)
        email = try? container.decode(String.self, forKey: .email)
        location = try? container.decode(String.self, forKey: .location)
        followers = try? container.decode(Int.self, forKey: .followers)
        following = try? container.decode(Int.self, forKey: .following)
        repoCount = try? container.decode(Int.self, forKey: .repoCount)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }

}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension UserProfile: Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}
