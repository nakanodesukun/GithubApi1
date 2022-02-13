//
//  File.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import Foundation

struct Issue: Codable {
    let number: Int?
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let updatedAt: String // 一覧画面・詳細画面に表示   // codingkeyが必要！！ここstring?に変更stringで取得してformattoする？？
    let user: User? // 一覧画面にアバター画像と名前を表示

    enum CodingKeys: String, CodingKey {
        case number, title, body, url, user
        case updatedAt = "updated_at"
    }
}
struct User: Codable {
    let login: String // ユーザー名
    let avaterURL: URL?
    enum CodingKeys: String, CodingKey {
        case login
        case avaterURL = "avatar_url"    //   URLが取得されるので対処必要
    }
}
