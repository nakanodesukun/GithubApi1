//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import Foundation
import UIKit
class UserListModel {
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }
    
    let apiModel = ApiModel()
    var apiArray: [Issue] = []


    func getApi() {
        apiModel.fetchData(urlString: urlString.TodoAppUrl) { (issue: [Issue]) in
            NotificationCenter.default.post(name:  Notification.Name("notifyName"), object: issue)
//            DispatchQueue.main.async {
////                self.apiArray.append(contentsOf: issue)
//                print("取得自体は成功")
//
//
//            }
        } failure: {
            print("エラー")
        }
    }
}
