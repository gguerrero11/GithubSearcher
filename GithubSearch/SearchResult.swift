//
//  SearchResult.swift
//  GithubSearch
//
//  Created by Gabe Guerrero on 4/24/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation

struct SearchResultUser: Codable {
    var count: Int?
    var items: [User]?
    
    enum CodingKeys: String, CodingKey {
        case count  = "total_count"
        case items  = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try? container.decode(Int.self, forKey: .count)
        items = try? container.decode([User].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

struct SearchResultRepo: Codable {
    var count: Int?
    var items: [Repo]?
    
    enum CodingKeys: String, CodingKey {
        case count  = "total_count"
        case items  = "items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try? container.decode(Int.self, forKey: .count)
        items = try? container.decode([Repo].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
