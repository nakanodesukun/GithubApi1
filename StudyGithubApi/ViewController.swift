//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
// Protocolでジェネリクスを定義する方法がわからない
//protocol IssueApi {
//    func fetchIssues<T: Decodable>(completion: (T) -> ())
//}


struct Issue: Codable {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let updatedAt: Date? // 一覧画面・詳細画面に表示
    let user: User // 一覧画面にアバター画像と名前を表示
    struct User: Codable {
        let login: String // ユーザー名
        let avaterURL: URL?
    }
}

class ViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tittleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchIssues { (Issue) in
//            Issue.forEach {(print($0.number))}
//        }
       // urlStringの引数を列挙にしたい
        // 配列の中に辞書データが入っている
        fetchIssues(urlString: "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues") { (Issues: [Issue]) in
            Issues.forEach {(print($0.body))}
        }
    }

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
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {
                print("dataの取得に失敗しました")
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print("dataの取得に失敗しました\(jsonErr)")
            }
        }.resume()
    }
}




extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
//            cell.titleLable.text =
        return cell
    }
}

