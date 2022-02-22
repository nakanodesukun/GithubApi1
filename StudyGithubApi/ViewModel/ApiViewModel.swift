//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//


import UIKit

/* MVVMを意識するとModelとViewは直接の依存関係を持ってはいけない。ViewModelはViewとModelの仲介役。
  ViewとViewModleのデータバインディングを行うには、CombineやRXSwiftを用いれば簡易的に行える。
 現状のスキルだとMVCやMVPアーキテクチャで書いた方が良い。しかし、MVCやMVPで記述するとFatViewControllerになってしまう。
 */
class ApiViewModel {
    // apiModelに処理させる
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
        static let FoldingMemoAppUrl = "https://api.github.com/repos/app-dojo-salon/FoldingMemoApp/issues"
    }
    
  private  let apiModel = ApiModel()


    func getApi() {
        apiModel.fetchData(urlString: urlString.FoldingMemoAppUrl) { result in
            // 成功と失敗の処理を分岐させ、結果をNotificationCenterでViewContorllerに渡す
            switch result {
            case .success(let issue):
//                issue.forEach{print($0.updatedAt)}

                                                    // インジケータを表示させるため処理遅延させる
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    // 時刻の変換
                        issue.forEach { time in
                        let date =  self.dateFromString(string: time.updatedAt)
                        let dateString = self.stringFromDate(date: date)
                            // ViewcontorllerへnotificationCenterを使って値を渡す
                        NotificationCenter.default.post(name: Notification.Name("notifyNameDate"), object: dateString)
                    }
                    // NotificationCenterでViewControllerへ値を渡す                           // 値を渡す
                    NotificationCenter.default.post(name:  Notification.Name("notifyName"),object: issue)
                }

            case .failure(let error):
                let errorTitle = error.title
                let errorMessage = error.message
                let errorActionTitle = error.actionTitle
                
                let alert = UIAlertController(title: errorTitle,
                                              message: errorMessage,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: errorActionTitle,
                                              style: .default,
                                              handler: nil))
                                                                                               // エラー内容を渡す
                NotificationCenter.default.post(name:  Notification.Name("notificationError"), object: alert)
            }
        }
    }

    // UpdateAtをString型で取得しているのでDate型に変換する
   private func dateFromString(string: String) -> Date {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
            return formatter.date(from: string)!
        }
    // Data型の値をString型に再変換し
   private func stringFromDate(date: Date) -> String {
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
            return formatter.string(from: date)
    }
}


