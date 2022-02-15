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
    func analyze(urlString: String, sucesse: @escaping ([Issue]) -> (), failure: @escaping () -> ()) {
        guard let url = URL(string: urlString) else { return }  // completionHandler内ではDelegateが使えない
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("error", error.localizedDescription)
            }
            guard let data = data else {
                print("dataの取得に失敗しました")
                failure()
                return
            }
            do {
                //↓ decodeしたときに中身が配列に入っているため
                let issueDecode = try JSONDecoder().decode([Issue].self, from: data)
                // 画面遷移する際delegateで特定の情報だけ渡すべき？？[[String: Any]]で入っている
                let issueTitle = issueDecode.map{$0.title }
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

