//
//  ImageDownlodeModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/16.
//

import UIKit

class ImageDownloderModel {

    func downloadImage(url: URL, success: @escaping (UIImage) -> Void) {
        // do-catch文にリファクタリングする // 通信中にインジーケータを表示する。
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                // 失敗した時のクロージャーを作る。　do-catchで大きく囲ってもいいかも
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
            } // 成功したらUIImage型のデータを渡す。
            success(imageData)
        }
        task.resume()
    }
}
