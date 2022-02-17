//
//  Parser.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import Foundation


class ApiViewModel {
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }
    // 副作用のあるメソッドなので動詞 Jsonに準拠させる　　　　　　　　　　　　　　　// どんなな型でも入れられる.
    func fetchData<T: Decodable>(urlString: String, sucesse: @escaping (T) -> (), failure: @escaping () -> ()) {
        guard let url = URL(string: urlString) else { return }  // completionHandler内ではDelegateが使えない
        var request = URLRequest(url: url)
               request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error", error.localizedDescription)
            }
            guard let data = data else {
                print("dataの取得に失敗しました")
                failure()
                return
            }
            do {
                                                        // ジェネリクスを用いることで型の変換を関数内部で変更しなくて済む
                let issueDecode = try JSONDecoder().decode(T.self, from: data)
                // 現在サブスレッドなのでメインスレッドへ
                DispatchQueue.main.async {
                    sucesse(issueDecode)
                }
            } catch   {
                print("deocdeに失敗", error)
                failure()
            }
        }
        task.resume()
    }
}

