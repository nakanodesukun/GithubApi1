//
//  Parser.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import UIKit


 final class ApiModel {
    // Error準拠させる。(Result<Sucess, Failure>型でエラー処理を行いたいため)
    enum ApiError: Error {
        case invalidURL
        case networkError
        
        var title: String {
            switch self {
            case .invalidURL:
                return "無効なURLです"
            case .networkError:
                return "通信に失敗しました"
            }
        }
        var message: String {    // コンピューテッドプロパティ
            switch self {
            case .invalidURL:
                return "URLを変更して下さい"
            case .networkError:
                return "リトライしますか？"
            }
        }
        var actionTitle: String {
            switch self {
            case .invalidURL:
                return "OK"
            case .networkError:
                return "リトライ"
            }
        }
    }
    //  Result<Sucess, Failure>型でエラー処理
    func fetchData(urlString: String,
                   completionHandler: @escaping (Result<[Issue], ApiError>) -> Void) {
        guard let url = URL(string: urlString) else {
            //
            completionHandler(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // guard let文は安全にプログラムを進めれるが,ユーザー目線で考えるとエラーの表示内容は限られるのでdo-catch文を使った。
            do {
                let error = try error
                let data = try data
                let issuesDecode = try JSONDecoder().decode([Issue].self, from: data!)
                // クロージャーでApiViewModelに成功した時の値を渡す。  // タプルの配列
                completionHandler(.success(issuesDecode))
            } catch  {
                // クロージャーでApiViewModelに失敗した値を渡す。
                completionHandler(.failure(.networkError))
            }
        }
        task.resume()
    }
}



