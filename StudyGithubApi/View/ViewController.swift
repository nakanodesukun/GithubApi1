//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
import Foundation

// ViewControllerに記述が多すぎる。NotificationCenterを使ってViewcontorllerの記述を減らせる？？

class ViewController: UIViewController {
    // 値を格納(TableView表示用)
    var arry:[Issue] = []
    //　アイコン取得
    var icon = [UIImage]()

    let userListModel = UserListModel()
    // 値を渡すグローバル変数
    var selectedText: Issue?

//    var avaterUrlArray = [Issue]()
    var avaterUrlArray = [UIImage]()
    let apiViewModel = ApiModel()
    let imageDownloderModel = ImageDownloderModel()


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        getUer()
        userListModel.getApi()
        NotificationCenter.default.addObserver(self, selector:  #selector(getApi), name: Notification.Name("notifyName"), object: nil)

    }
    // NotificationでViewModelから通知を受け取る
    @objc func getApi(notification: Notification) {
        guard let api = notification.object as? [Issue] else {
            print("エラー")
            return
        }
//        arry = api
        print(api)
        arry = api
        DispatchQueue.main.async {
//            print(api)
//            print("成功しました")
            self.arry = api
            self.tableView.reloadData()
        }

    }
    

    @IBAction func exit(segue:UIStoryboardSegue)  {

    }
//    // JsonでDecode　　　// urlを取得する引数を作る
//    func getUer() {                                                                                  // ここで具体的に欲しい値を取得する
//        apiViewModel.fetchData(urlString: "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues") { (issue: [Issue]) in
//            DispatchQueue.main.async { [weak self] in
//                self?.arry = issue
//                self?.tableView.reloadData()
//            }
//        } failure: {
//            DispatchQueue.main.async {
//                self.alert()
//            }
//        }
//    }



    // アラート表示用メソッド　エラーの内容によって内容を変える  また、省略できるところはする
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
        cell.configure(item: arry[indexPath.row])

        // 画像の取得/表示
        imageDownloderModel.downloadImage(url: arry[indexPath.row].user.avaterURL, success: { image in
            DispatchQueue.main.async { [weak self] in
                cell.iconView.image = image
            }
        })

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
