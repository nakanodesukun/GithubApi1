//
//  File.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import Foundation

struct Issue: Codable  {
    let number: Int
    let title: String
    let body: String
    let url: URL
    let updatedAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case number, title, body, url, user
        case updatedAt = "updated_at"
    }
}

struct User: Codable {
    let login: String // ユーザー名
    let avaterURL: URL
    enum CodingKeys: String, CodingKey {
        case login
        case avaterURL = "avatar_url"
    }
}
