//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit


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

class ViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tittleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        GithubApi()
    }
    func GithubApi() {
        guard let url = URL(string: "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues") else { return }
        //　いらない
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print("情報の取得に失敗しました")
                return
            }

            if let data = data {
                do {
//                    let github = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                                  //   指定したものだけ取り出す
                    let github = try JSONDecoder().decode(Issue.self, from: data)
                    print("情報の取得に成功しました")
                    print(github)
//                    print(github[3])
                    DispatchQueue.main.async {
//
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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell

        return cell
    }
}

