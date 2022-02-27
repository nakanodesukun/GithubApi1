//
//  CustomCell.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit

final class CustomCell: UITableViewCell {
    
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var updateDateLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!

    
    func configure(item: Issue, updateAt: String) {
        titleLable.text = item.title
        updateDateLabel.text = updateAt
    }
    func IconViewConfigure(imageView: UIImage) {
        iconView.image = imageView
    }

}
