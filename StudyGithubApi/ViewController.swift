//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
//
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
//
//struct User: Codable {
//    let body: String
//    let title: String
//}
class ViewController: UIViewController  {
    // パースした[String: Any]型のクーポンデータを格納するメンバ変数Arry
//    var coupons:[[String: Any]] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tittleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = "https://api.github.com/repos/octocat/Hello-World/issues/1347"
//        guard var urlComponents = URLComponents(string: url) else { return }
//        print(urlComponents)
//        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, err in
//            if let error = err {
//                print(err, "エラーです")
//            }
//            if let data = data {
//                do {
//                    // 特定のものだけ出力する
//                    let issue = try JSONDecoder().decode([Issue].self, from: data)
////                    let issue = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                    print(issue)
//                } catch {
//                    print(error.localizedDescription,"取得できませんでした")
//                    print(err)
//                }
//            }
//        }
//        task.resume()
        GithubApi()
    }
    func GithubApi() {
        guard let url = URL(string: "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues") else { return }
        // ここが重要
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print("情報の取得に失敗しました")
                return
            }

            if let data = data {
                do {
//                    let github = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                                  //   指定したものだけ取り出す
                    let github = try JSONDecoder().decode([Issue].self, from: data)
                    print("情報の取得に成功しました")
                    print(github)
//                    print(github[3])
                    DispatchQueue.main.async {
//                        self.tittleLabel.text = github[0].title
                        }

                } catch(let err) {
                    print(err)
                }
            }
        })
        task.resume()
    }
}




extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        // 上から下へ1行ずつ表示する
//        let coupon = self.coupons[indexPath.row]
////        print(coupon)
//        cell.titleLable.text = (coupon["title"] as! String)
//        cell.titleImage.image = (coupon["avatar_url"] as! UIImage)
        
        return cell
    }
}

