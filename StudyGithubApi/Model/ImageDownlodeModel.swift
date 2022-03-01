//
//  ImageDownlodeModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/16.
//

import UIKit

final class ImageDownlodeModel {
    func downloadImage(url: URL, success: @escaping (UIImage) -> Void) {
        // do-catch文にリファクタリングする
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // guard let文は安全にプログラムを進めれるが,ユーザー目線で考えるとエラーの表示内容は限られるのでdo-catch文を使った。
            do {
                let error = try error
                let response = try response
                let data = try data
                let imageData = UIImage(data: data!)
                // 成功したらUIImage型のデータを渡す。
                success(imageData!)
            } catch {
                print(error.localizedDescription)}
        }
        task.resume()
    }
}
