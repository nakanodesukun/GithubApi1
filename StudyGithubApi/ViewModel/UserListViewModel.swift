//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import Foundation
class UserListModel {
    
    var issueUser:[Issue] = []
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }


// ViewModelのclassでsuccessだったら配列に入れる。失敗だったらクロージャーを使ってそのままViewcontrollerに渡す
//    let analyzeModelView = AnalyzeViewModel()
//    func getUer() {
//        analyzeModelView.fetchData(urlString: urlString.TodoAppUrl) { (Issue) in
//
//              DispatchQueue.main.async {
//          //                self.delegate?.fetchIssues(sucesse: Issue)
//                  Issue.forEach({print($0.title)})
//
//              }
//          } failure: {
//              DispatchQueue.main.async {
//
//              }
//          }
//       }

}
