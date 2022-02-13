//
//  Parser.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import Foundation

struct Parser {

    //    func fetchIssues(completion: @escaping ([Issue]) -> ()) {
    //        let urlString = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    //        let url = URL(string: urlString)
    //        URLSession.shared.dataTask(with: url!) { (data, response, err) in
    //            guard let data = data else {
    //                print("dataの取得に失敗しました")
    //                return
    //            }
    //            do {
    //                let homfeed = try JSONDecoder().decode([Issue].self, from: data)
    //                completion(homfeed)
    //            } catch let jsonErr {
    //                print("dataの取得に失敗しました\(jsonErr)")
    //            }
    //        }.resume()
    //    }

        /*
        ジェネリクスを使ってどんな方でも許容する。汎用性が高い。URLから取得したJSONの型によって配列の有無が異なる。
        その為、関数の内部でdecodeする時に配列にするかどうか切り替えなければならい。よって、ジェネリクスを使い関数内部処理しないようにする。
        */
        func fetchIssues<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
            let urlString = urlString
            let url = URL(string: urlString)
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"

            URLSession.shared.dataTask(with: url!) { (data, response, err) in
                if let err = err {
                    print(err)
                }
                guard let data = data else {
                    print("dataの取得に失敗しました")
                    return
                }
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(obj)
                } catch let jsonErr {
                    print("デコードに失敗しました\(jsonErr)")
                }
            }.resume()
        }
}
