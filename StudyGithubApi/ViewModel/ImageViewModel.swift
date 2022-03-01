//
//  File.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/26.
//

import UIKit

final class ImageViewModel {
    private let imageDownlodeModel = ImageDownlodeModel()

    private var issueUrl: URL

    init(issueUrl: URL) {
        self.issueUrl = issueUrl
    }

    func getIamgeView(imageHandler: @escaping (UIImage) -> Void) {
        imageDownlodeModel.downloadImage(url: issueUrl) { image in
            imageHandler(image)
        }
    }
}
