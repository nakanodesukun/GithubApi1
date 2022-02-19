//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit

// ViewControllerに記述が多すぎる。NotificationCenterを使ってViewcontorllerの記述を減らせる？？

class ViewController: UIViewController {

    let apiListModel = ApiListViewModel()

    let imageDownloderModel = ImageDownloderModel()
    // 値を格納(TableView表示用)
    var IssueArry:[Issue] = []
    // 値を渡すグローバル変数
    var selectedText: Issue?

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 画面が表示されるタイミングで発火させる
        apiListModel.getApi()
        // ViewModelから通知を受け取る  　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　// タイプミスがあるので定数で保持するように変更
        NotificationCenter.default.addObserver(self, selector:  #selector(getApi),
                                               name: Notification.Name("notifyName"),
                                               object: nil)
        // ViewModelからエラー通知を受け取る                                                            　// タイプミスがあるので定数で保持するように変更
        NotificationCenter.default.addObserver(self, selector: #selector(getApierror),
                                               name: Notification.Name("notificationError"),
                                               object: nil)
    }
    // ViewModelから通知を受け取る
    @objc func getApi(notification: Notification) {
        guard let api = notification.object as? [Issue] else {
            print("Notification型から[Issue]型の変換に失敗")
            //            self.alert(title: "エラー", message: "通信に失敗しました")
            return
        }
        IssueArry = api
        DispatchQueue.main.async { [weak self] in
            self?.IssueArry = api

            self?.tableView.reloadData()
            print( )
        }
    }
    // ViewModelからerror通知を受け取る
    @objc func getApierror(notification: Notification) {
        // Notification型からUIAlertController型に変換
        guard let alert = notification.object as? UIAlertController else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.present(alert,
                          animated: true,
                          completion: nil)
        }
    }
    @IBAction func exit(segue:UIStoryboardSegue)  {
        
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IssueArry.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        cell.configure(item: IssueArry[indexPath.row])
        
        // 画像の取得/表示  // クロージャーでそのままImageDownLoderModelから取得
        imageDownloderModel.downloadImage(url: IssueArry[indexPath.row].user.avaterURL,
                                          success: { image in
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
        tableView.deselectRow(at: indexPath, animated: true)
        // 詳細画面に特定のデータを渡す
        selectedText = IssueArry[indexPath.row]

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
