//
//  File.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/26.
//

import UIKit
class ImageViewModel {
    let imageDownlodeModel = ImageDownlodeModel()

   private var issueUrl: URL?

   init(issueUrl: URL) {
       self.issueUrl = issueUrl
    }

    func getIamgeView(imageHandler: @escaping (UIImage) -> Void) {
        imageDownlodeModel.downloadImage(urlString: issueUrl!) { image in
            imageHandler(image)
        }
    }
}
    extension UIImage {
        func resize(targetSize: CGSize) -> UIImage {
            return UIGraphicsImageRenderer(size:targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
}
