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
    
    let apiModel = ApiModel()


    func getApi() {
        apiModel.fetchData(urlString: urlString.TodoAppUrl) { result in
            // 成功と失敗の処理を分岐させ、結果をNotificationCenterでViewContorllerに渡す
            switch result {
            case .success(let issue):
                                                    // インジケータを表示させるため処理遅延させる
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
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
}


