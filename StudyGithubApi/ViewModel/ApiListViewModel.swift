//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import Foundation

class ApiListViewModel {
    
    let apiModel = ApiModel()

    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
        static let FoldingMemoAppUrl = "https://api.github.com/repos/app-dojo-salon/FoldingMemoApp/issues"
    }

    func getApi() {                                                   // ここに
        apiModel.fetchData(urlString: urlString.TodoAppUrl) { (issue: [Issue]) in
            NotificationCenter.default.post(name:  Notification.Name("notifyName"), object: issue)

        } failure: { //エラーを分岐させたい
            NotificationCenter.default.post(name: Notification.Name("notificationError"), object: nil)
            print("エラー")
            
        }
    }
}
