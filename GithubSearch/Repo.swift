//
//  Repo.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation

struct Repo: Codable {
    var id: Int?
    var name: String?
    var url: String?
    var forks: Int = 0
    var stars: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id             = "id"
        case name           = "name"
        case url            = "html_url"
        case forks          = "forks"
        case stars          = "stargazers_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name) 
        url = try? container.decode(String.self, forKey: .url)
        forks = try container.decode(Int.self, forKey: .forks)
        stars = try container.decode(Int.self, forKey: .stars)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }

}

extension Repo: Hashable {
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        return lhs.id == rhs.id
    }
}
