//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.

import UIKit

final class ViewController: UIViewController {

    private let apiViewModel = ApiViewModel()
    // ApiViewModelから値を受け取る
    private var issuesItems:[Issue] = []
    //　変換した日付を配列で保持する
    private var dateItems:[String] = [] 
    // TableViewが選択されたときに値を受け取ってDetailViewControllerへ渡すメンバ変数
    private var selectedItem: Issue?
    //  TableViewが選択されたときに値を受け取ってDetailViewControllerへ渡すメンバ変数
    private var selectedDate: String?
    //　タイプミスの恐れがあるので定数で保持
    private let detailViewController = "DetailViewController"
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()  // アニメーション開始
        bindApiData()
        tableView.register(CustomCell.nibName, forCellReuseIdentifier: CustomCell.nibId)
    }

    private func bindApiData() { //　クロージャーの循環参照する？？
        apiViewModel.getApi { issues  in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()    // アニメーション終了
                self?.activityIndicatorView.hidesWhenStopped = true  // アニメーション非表示
                self?.issuesItems = issues

                issues.forEach { issue in
                    guard let date =  self?.dateFromString(string: issue.updatedAt),
                          let dateString = self?.stringFromDate(date: date) else { return }
                    // 変換した日付を
                    self?.dateItems.append(dateString)
                }
                self?.tableView.reloadData()
            }

        } failure: { error in
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: error.title, message: error.message, actionTitle: error.actionTitle)
                self?.tableView.reloadData()
            }
        }
    }

    // UIに関わるのでViewで処理
    private func dateFromString(string: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return formatter.date(from: string)!
    }
    // UIに関わるのでViewで処理
    private func stringFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        return formatter.string(from: date)
    }
    // UIに関わるのでViewで処理
    private func showAlert(title: String, message: String, actionTitle: String) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.nibId, for: indexPath) as? CustomCell else {
            fatalError("")
        }

        cell.configure(issuesItems: issuesItems[indexPath.row], updateDate: dateItems[indexPath.row])
        // ImageViewModelを呼び出して画像を取得する
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
        selectedItem = issuesItems[indexPath.row]
        selectedDate = dateItems[indexPath.row]
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
            guard let selectedItem = selectedItem,
                  let selectedData = selectedDate else {
                      return
                  }
            // 次の画面への値渡し
            detailViewcontroller.selectedIssue = selectedItem
            detailViewcontroller.selectedDate = selectedData
        default:
            break
        }
    }
}
