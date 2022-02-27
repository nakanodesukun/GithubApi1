//
//  ImageDownlodeModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/16.
//

import UIKit
// Viewと依存関係にあると考えられるのでViewModelとした。

final class ImageDownlodeModel {
    func downloadImage(urlString: URL, success: @escaping (UIImage) -> Void) {
//        guard let urlString = URL(string: urlString) else { return  }
        // do-catch文にリファクタリングする
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // guard let文は安全にプログラムを進めれるが,ユーザー目線で考えるとエラーの表示内容は限られるのでdo-catch文を使った。
            do {
                let error = try error
                let data = try data
                let imageData = UIImage(data: data!)
                // 成功したらUIImage型のデータを渡す。
                success(imageData!)
            } catch {
                print("失敗しました", error.localizedDescription)}
//            failure(error!)
        }
        task.resume()
    }
}
