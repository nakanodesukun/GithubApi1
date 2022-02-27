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
