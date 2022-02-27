//
//  File.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/26.
//

import Foundation
class ImageViewModel {
    let imageDownlodeModel = ImageDownlodeModel()

    var issueUrl: URL?

   init (issueUrl: URL) {
       self.issueUrl = issueUrl
    }

    var delegate: IssueApiDelegate?

    func getIamgeView() {
        print(issueUrl)
//         modelから値を取得する？？
        imageDownlodeModel.downloadImage(urlString: (issueUrl ?? URL(string: "https://avatars.githubusercontent.com/u/1?v=4"))!) { image in

        }

    }

}
