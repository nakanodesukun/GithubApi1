//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    // 値を格納(TableView表示用)
    var arry:[Issue] = []
    //　アイコン取得
    var icon: UIImage?

    // 値を渡すグローバル変数
    var selectedText: Issue?

//    var avaterUrlArray = [Issue]()
    var avaterUrlArray = [UIImage]()
    let apiModel = ApiModel()
    let imageDownloderModel = ImageDownloderModel()




    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUer()

    }
    @IBAction func exit(segue:UIStoryboardSegue)  {

    }

    func getUer() {                                                                                  // ここで具体的に欲しい値を取得する
        apiModel.fetchData(urlString: "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues") { (issue: [Issue]) in
            DispatchQueue.main.async { [weak self] in
                self?.arry = issue
//                print(self?.arry[0].user.avaterURL)
//                self?.avaterUrlString = arry.filter{ $0 != "title"}
                self?.tableView.reloadData()
            }
        } failure: {
            DispatchQueue.main.async {
                self.alert()
            }
        }
    }

    func getImage(url: URL) {
        imageDownloderModel.downloadImage(url: url) { image in
            self.imageDownloderModel.downloadImage(url: url) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.icon = image
                    print(image)
                    self?.tableView.reloadData()
                }
            }
        }
    }

    func alert() {
        let dialog = UIAlertController(title: "エラー", message: "リトライしますか？", preferredStyle: .alert)
        //ボタンのタイトル
        dialog.addAction(UIAlertAction(title: "リトライ", style: .default, handler: nil))
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

//        cell.iconView.image = arry[indexPath.row].user.avaterURL
        getImage(url: arry[indexPath.row].user.avaterURL)
        // 画像の取得ができない
        cell.iconView.image = icon
        return cell
    }


}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        //     tableView.deselectRow(at: indexPath, animated: true)
        // 詳細画面に特定のデータを渡す
        selectedText = arry[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        // 画面遷移
        performSegue(withIdentifier: "showDetails", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let nav = segue.destination as! UINavigationController
            let detaileViewController = nav.topViewController as! DetailViewController
            detaileViewController.selectedText = selectedText
        }
    }
}
