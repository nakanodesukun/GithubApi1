//
//  Parser.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import Foundation
import UIKit


class ApiModel {
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
    func fetchData(urlString: String, completionHandler: @escaping (Result<[Issue], ApiError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
               request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error", error.localizedDescription)
            }
            guard let data = data else {
                print("dataの取得に失敗しました")
                return
            }
            do {
                let issueDecode = try JSONDecoder().decode([Issue].self, from: data)
                // 現在サブスレッドなのでメインスレッドへ
                    completionHandler(.success(issueDecode))
//                    issueDecode.forEach{print($0.user.avaterURL)}

                
            } catch  {
                completionHandler(.failure(.networkError))
//                print("deocdeに失敗", error)

            }
        }
        task.resume()
    }
}



