//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//


import UIKit

final class ApiViewModel {

    private let apiModel = ApiModel()
//    private let imageViewModel = ImageViewModel()
    
//    weak var delegate: IssueApiDelegate?

    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }
    
    func getApi(sucessIssue: @escaping([Issue]) -> Void, sucessDate: @escaping ([String]) -> Void, failure: @escaping (ApiModel.ApiError) -> Void) {
        apiModel.fetchData(urlString: urlString.TodoAppUrl) { [weak self] result in
            // 成功と失敗の処理を分岐させ、結果をNotificationCenterでViewContorllerに渡す
            switch result {
            case .success(let issues):
                // インジケータを表示させるために処理遅延させる
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                    var dateItems:[String] = []
                   //  時刻の変換
                    issues.forEach { issue in
                        guard let date =  self?.dateFromString(string: issue.updatedAt),
                              let dateString = self?.stringFromDate(date: date) else { return }
                        dateItems.append(dateString)
                    }
                    sucessDate(dateItems)
                    sucessIssue(issues)
                }
            case .failure(let error):
                failure(error)
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


