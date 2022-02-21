//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//
import UIKit

// ViewControllerに記述が多すぎる。NotificationCenterを使ってViewcontorllerへの
class ViewController: UIViewController {

    let apiViewModel = ApiViewModel()

    let imageDownloderModel = ImageDownloderModel()
    // 値を格納(TableView表示用)
    var IssueArry:[Issue] = []
    // TableViewが選択されたときに次の画面へ値を渡すグローバル変数
    var selectedText: Issue?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // インジケータの表示開始
        activityIndicatorView.startAnimating()

        // 画面が表示されるタイミングで発動
        apiViewModel.getApi()
        // ApiViewModelから通知を受け取る  　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　// タイプミスがあるので定数で保持するように変更
        NotificationCenter.default.addObserver(self, selector:  #selector(getApi),
                                               name: Notification.Name("notifyName"),
                                               object: nil)
        // ApiViewModelからエラー通知を受け取る                                                            　// タイプミスがあるので定数で保持するように変更
        NotificationCenter.default.addObserver(self, selector: #selector(getApierror),
                                               name: Notification.Name("notificationError"),
                                               object: nil)
    }
    // ApiViewModelから通知を受け取る
    @objc func getApi(notification: Notification) {
        guard let api = notification.object as? [Issue] else {
            return
        }   // UIの更新                    //　循環参照を避ける
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()    // アニメーション終了
            self?.activityIndicatorView.hidesWhenStopped = true  // アニメーション非表示
            self?.IssueArry = api
            self?.tableView.reloadData()
        }

    }
    // ViewModelからerror通知を受け取る
    @objc func getApierror(notification: Notification) {
        // Notification型からUIAlertController型に変換
        guard let alert = notification.object as? UIAlertController else {
            return
        }
           // 処理の終了を待ってから実行     // 循環参照を避ける
        DispatchQueue.main.async { [weak self] in
            self?.present(alert,
                          animated: true,
                          completion: nil)
            self?.tableView.reloadData()
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
        // 詳細画面に特定のデータを渡す       // delegateでなくnotificationCenterを使って値を渡す方がいい？？
        selectedText = IssueArry[indexPath.row]
        
        // 画面遷移
        performSegue(withIdentifier: "DetailViewController", sender: self)

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            let nav = segue.destination as! UINavigationController
            let detaileViewController = nav.topViewController as! DetailViewController
            detaileViewController.selectedText = selectedText
        }
    }
}
