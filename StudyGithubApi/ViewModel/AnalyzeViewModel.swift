//
//  Parser.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/13.
//

import Foundation
protocol IssueApiDelegate: AnyObject  {
    func fetchIssues(sucesse: [Issue])
}

class AnalyzeViewModel {


    // 副作用のあるメソッドに
    func analyze(urlString: String, sucesse: @escaping ([Issue]) -> (), err: @escaping () -> ()) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("error", error.localizedDescription)
            }
//            guard let data = data else {
//                print("dataの取得に失敗しました")
//                err()
//                return
//            }
            do {
                //↓ decodeしたときに中身が配列に入っているため
                let issueDecode = try JSONDecoder().decode([Issue].self, from: data!)
                // 画面遷移する際delegateで特定の情報だけ渡すべき？？
                let issueTitle = issueDecode.map{$0.title }
//                print(issueDecode)
                sucesse(issueDecode)
            } catch   {
                print("deocdeに失敗", error)
                err()

            }
        }
        task.resume()
    }
}
/*
 ジェネリクスを使ってどんな方でも許容する。汎用性が高い。URLから取得したJSONの型によって配列の有無が異なる。
 その為、関数の内部でdecodeする時に配列にするかどうか切り替えなければならい。よって、ジェネリクスを使い関数内部処理しないようにする。
 */
//        func fetchIssues<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
//            let urlString = urlString
//            let url = URL(string: urlString)
//    //        var request = URLRequest(url: url)
//    //        request.httpMethod = "GET"
//
//           let task = URLSession.shared.dataTask(with: url!) { (data, response, err) in
//                if let err = err {
//                    print(err)
//                }
//                guard let data = data else {
//                    print("dataの取得に失敗しました")
//                    return
//                }
//                do {
//                    let obj = try JSONDecoder().decode(T.self, from: data)
//                    // successに変更
//                    completion(obj)
//                } catch let jsonErr {
//                    print("デコードに失敗しました\(jsonErr)")
//                }
//            }
//            task.resume()
//        }


