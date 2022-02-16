//
//  ImageDownlodeModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/16.
//

import Foundation
import UIKit


class ImageDownloderModel {
    func downloadImage(url: URL, success: @escaping(UIImage) -> Void) {
//        guard let url = URL(string: urlString) else {
//            print("エラー")
//            return
//        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("エラー", error)
            }
            guard let data = data else {
                print("データの取得に失敗しました")
                return
            }
                                  // UIImage型に変換
            guard let imageData = UIImage(data: data) else {
                print("型の変換に失敗しました")
                return
            }
            success(imageData)
        }
        task.resume()
    }
}
