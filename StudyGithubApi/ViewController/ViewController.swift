//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var arry:[Issue] = []

    
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let  analyzeModelView = AnalyzeViewModel()
        analyzeModelView.analyze(urlString: urlString.TodoAppUrl) { (Issue) in
            Issue.forEach({print($0.title)})
            DispatchQueue.main.async {
                self.arry = Issue
                self.tableView.reloadData()
            }
        } err: {
            DispatchQueue.main.async {
                self.alert()
            }
        }
    }
    @IBAction func exit(segue:UIStoryboardSegue)  {

            }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arry.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        cell.titleLable.numberOfLines = 0
        cell.titleLable.text = arry[indexPath.row].title
        cell.updateDateLabel.text = arry[indexPath.row].updatedAt
        // 画像の取得ができない
        cell.avaterImageView.image = arry[indexPath.row].user.avaterURL as? UIImage
        return cell
    }
    func alert() {
        let title = "通信に失敗しました"
        let message = "リトライしますか?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "リトライ", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
     tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "Cell2", sender: nil)
    }
}
