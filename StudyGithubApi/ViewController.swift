//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit

struct User: Codable {
    let body: String
    let title: String
 }


class ViewController: UIViewController  {

    @IBOutlet weak var tittleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        GithubApi()
    }
    func GithubApi() {
        guard let url = URL(string: "https://api.github.com/repos/minmin0530/dragon_puzzle/issues") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print("情報の取得に失敗しました")
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let github = try JSONDecoder().decode([User].self, from: data)
                    print("情報の取得に成功しました")
                    print(github)
                    print(github[3])
                    DispatchQueue.main.async {
                        self.tittleLabel.text = github[2].title
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
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        return cell
    }
}

