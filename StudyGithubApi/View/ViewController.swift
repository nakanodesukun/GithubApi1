//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//
import UIKit
protocol IssueApiDelegate: AnyObject {
    func fetchIssue(issue: [Issue], date: String)
//    func fetchAvaterURL(iamge: UIImage)
    func fetchImageView(image: UIImage)
}


final class ViewController: UIViewController, IssueApiDelegate {

    private let apiViewModel = ApiViewModel()
//    private let imageViewModel = ImageViewModel()

    // Notificationから取得した値を保持する(TableView表示用)
    private var issueItems:[Issue] = []
    //　ApiViewModelから時刻の表示を受けとる
    private var dateString: String = ""
//    var imageViewModel = ImageViewModel(issueUrl: )

    var Iconimage: UIImage?
    // TableViewが選択されたときに次の画面へ値を渡すグローバル変数
    private var selectedText: Issue?
    //　タイプミスの恐れがあるので定数で保持
    private let detailViewController = "DetailViewController"
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // インジケータの表示開始
        activityIndicatorView.startAnimating()

//        imageViewModel.getIamgeView()
//        imageViewModel.delegate = self
        
        // 画面が表示されるタイミングで発動
        apiViewModel.getApi()
//        imageViewModel.getIamgeView()
        apiViewModel.delegate = self
//        imageViewModel.delegate = self

        // ApiViewModelからエラー通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(getApiError),
                                               name: .notifyError,
                                               object: nil)
    }
    
    func fetchIssue(issue: [Issue], date: String) {
        issueItems = issue
        dateString = date
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()    // アニメーション終了
            self?.activityIndicatorView.hidesWhenStopped = true  // アニメーション非表示
            self?.tableView.reloadData()
        }
    }

    func fetchImageView(image: UIImage) {
        Iconimage = image
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    // ViewModelからerror通知を受け取る
    @objc func getApiError(notification: Notification) {
        guard let alert = notification.object as? UIAlertController else {
            return
        }
        // UIの更新                   // 循環参照を避ける
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
        issueItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        cell.configure(item: issueItems[indexPath.row], updateAt: dateString)
        cell.iconView.image = Iconimage
        // 画像の取得/表示  // クロージャーでそのままImageDownLoderModelから取得
//        imageDownlodeModel.downloadImage(urlString: issueItems[indexPath.row].user.avaterURL,
//                                          success: { [weak self]  image in
//            DispatchQueue.main.async { [weak self] in
//                cell.iconView.image = image
//            }
//        })

        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 詳細画面に特定のデータを渡す
        selectedText = issueItems[indexPath.row]
        // 画面遷移
        performSegue(withIdentifier: detailViewController, sender: nil)
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // switch文にすることで他のIdentifierも登録可能
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
            detailViewcontroller.dateText = dateString
        default:
            break
        }
    }
}
