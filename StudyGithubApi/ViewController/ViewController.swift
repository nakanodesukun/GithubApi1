//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    let parser = AnalyzeModelView()
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }
    
    var IssueArry: [Issue]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let analyzeModelView = AnalyzeModelView()
        analyzeModelView.analyze()
//        fetchIssues { (Issue) in
//            Issue.forEach {(print($0.number))}
//        }
       // urlStringの引数を列挙にしたい
        // 配列の中に辞書データが入っている                                      //[]だけ変更すればよい
//        parser.fetchIssues(urlString: urlString.TodoAppUrl) { (Issues: [Issue]) in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }

            // 配列に入っている辞書データを用意した空の配列に保持。保持したものをTableViewCellに保存したい
//            Issues.forEach {(print($0.body))}
//            // 配列の中に辞書型が入っている
//            print("取得", Issues)
//            self.IssueArry = Issues
////            self.tableView.reloadData() // DispatchQue.main.asnyc{}に書き込めば紫色が消えた
//        }
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IssueArry?.count ?? 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        cell.titleLable.numberOfLines = 0
        cell.titleLable.text = IssueArry?[indexPath.row].title
        if let update = IssueArry?[indexPath.row].updatedAt  {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: update)
            if let date = date {
                cell.updateDateLabel.text = "更新日\(date)"
                print(update)
                print(date)
            }

        } else {
            cell.updateDateLabel.text = "更新日\(IssueArry?[indexPath.row])"
        }
//        if  let avatarImage = IssueArry?[indexPath.row].user?.avaterURL {
//            print("取得に成功しました\(avatarImage)")
//
//        } else {
//            print("取得に失敗しました")
//        }
        let urlString = IssueArry?[indexPath.row].user.avaterURL
        let url = URL(string: "\(urlString)")


//        do {
//            let data = try Data(contentsOf: url!)
//            cell.avaterImageView.image = UIImage(data: data)  // nil host used in call to allowsSpecificHTTPSCertificateForHostというエラーが出る。akioさんのYouthube
//        } catch  let err{
//            print("エラーです\(err)")
//        }
        do {
            let url = URL(string: "https://avatars.githubusercontent.com/u/72324850?v=4")
            let data = try Data(contentsOf: url!)
            cell.avaterImageView.image = UIImage(data: data)
        } catch {
            print("モックデータの表示に失敗しました")
        }

        return cell
    }
}

