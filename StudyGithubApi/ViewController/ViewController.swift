//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
import Foundation

class ViewController: UIViewController {
//    var delegate: IssueApiDelegate?

    var arry:[Issue] = []
    let analyzeModelView  = AnalyzeViewModel()



    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUer()

    }
    @IBAction func exit(segue:UIStoryboardSegue)  {

    }

    func getUer() {
        analyzeModelView.analyze(urlString: "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues") { (Issue) in

            DispatchQueue.main.async { [self] in
       //                self.delegate?.fetchIssues(sucesse: Issue)
               Issue.forEach({print($0.title)})
               arry = Issue
               self.tableView.reloadData()
           }
       } failure: {
           DispatchQueue.main.async {
               self.alert()
           }
       }
    }
    func alert() { 
        let dialog = UIAlertController(title: "タイトル", message: "サブタイトル", preferredStyle: .alert)
        //ボタンのタイトル
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //実際に表示させる
        present(dialog, animated: true, completion: nil)
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


}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
     tableView.deselectRow(at: indexPath, animated: true)

        // 画面遷移
        performSegue(withIdentifier: "Cell2", sender: indexPath.row)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cell2" {
            let nav = segue.destination as! UINavigationController
            let detaileViewController = nav.topViewController as! DetailViewController
            detaileViewController.detail = arry
            // モデルそのものを渡す
            detaileViewController.title = 
        }
    }
}
