//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.

import UIKit

final class ViewController: UIViewController {

    private let apiViewModel = ApiViewModel()
    // Notificationから取得した値を保持する(TableView表示用)
    private var issuesItems:[Issue] = []
    //　ApiViewModelから時刻の表示を受けとる
    private var dateString: [String] = []
    // TableViewが選択されたときに値を受け取ってDetailViewControllerへ渡すメンバ変数
    private var selectedText: Issue?
    //  TableViewが選択されたときに値を受け取ってDetailViewControllerへ渡すメンバ変数
    private var selectedDate: String?
    //　タイプミスの恐れがあるので定数で保持
    private let detailViewController = "DetailViewController"
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()  // アニメーション開始

        apiViewModel.getApi { issue in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()    // アニメーション終了
                self?.activityIndicatorView.hidesWhenStopped = true  // アニメーション非表示
                self?.issuesItems = issue
                self?.tableView.reloadData()
            }
        } sucessDate: { date in
            DispatchQueue.main.async { [weak self] in
                self?.dateString = date
                self?.tableView.reloadData()
            }
        } failure: { error in
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: error.title, message: error.message, actionTitle: error.actionTitle)
                self?.tableView.reloadData()
            }
        }
    }
     // UI表示はViewContollerで
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func exit(segue:UIStoryboardSegue)  {
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        issuesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell

        cell.configure(issuesItems: issuesItems[indexPath.row], updateDate: dateString[indexPath.row])

        ImageViewModel(issueUrl: issuesItems[indexPath.row].user.avaterURL).getIamgeView { imageView in
            DispatchQueue.main.async {
                cell.IconViewConfigure(imageView: imageView)
            }
        }
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 詳細画面に特定のデータを渡す
        selectedText = issuesItems[indexPath.row]
        selectedDate = dateString[indexPath.row]

        // 画面遷移
        performSegue(withIdentifier: detailViewController, sender: nil)
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if文だとネストが深くなるのでswitch文にする
        switch segue.identifier {
        case detailViewController:
            guard let navigationCentroller = segue.destination as? UINavigationController,
                  let detailViewcontroller = navigationCentroller.topViewController as? DetailViewController else {
                      return
                  }
            guard let selectedText = selectedText else {
                return
            }
            // 次の画面への値渡し
            detailViewcontroller.selectedText = selectedText
            detailViewcontroller.dateText = selectedDate
        default:
            break
        }
    }
}
