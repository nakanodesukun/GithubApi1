//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import UIKit

class ApiViewModel {

    enum UrlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
        static let FoldingMemoAppUrl = "https://api.github.com/repos/app-dojo-salon/FoldingMemoApp/issues"
    }

    let apiModel = ApiModel()
  // NotificationCenterを使ってViewから
    func getApi() {
        apiModel.fetchData(urlString: ) { result in
            switch result {
            case .success(let issue):
                 // 値を渡す
                NotificationCenter.default.post(name: Notification.Name("notifyName"), object: issue)

            case .failure(let error):
                let errorTitle = error.title
                let errorMessage = error.message
                let errorActionTitle = error.actionTitle
                let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: errorActionTitle, style: .default, handler: nil))
                                                                                               // エラー内容を渡す
                NotificationCenter.default.post(name: Notification.Name("notificationError"), object: alert)
            }
        }
    }
}
