//
//  Repository.swift
//  testeModal
//
//  Created by Fernanda de Lima on 14/05/20.
//  Copyright © 2020 felima. All rights reserved.
//

import Foundation

struct Repository: Codable{
    var items: [Item]
}

struct Item: Codable{
    var name:   String
    var stargazers_count:  Int
    var owner:  Owner
}

struct Owner: Codable{
    var login: String
    var avatar_url: String
}
