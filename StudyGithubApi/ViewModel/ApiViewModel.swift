//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//


import UIKit

final class ApiViewModel {
    
    private let apiModel = ApiModel()

    func getApi(sucessIssue: @escaping([Issue]) -> Void, failure: @escaping (ApiModel.ApiError) -> Void) {
        apiModel.fetchData { [weak self] result in
            // 成功と失敗の処理を分岐させ、結果をNotificationCenterでViewContorllerに渡す
            switch result {
            case .success(let issues):
                // インジケータを表示させるために処理遅延させる
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                    sucessIssue(issues)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}


