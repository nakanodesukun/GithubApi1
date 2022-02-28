//
//  CustomCell.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit

final class CustomCell: UITableViewCell {

    static let nibName = UINib(nibName: "CustomCell", bundle: nil)
    static let nibId = "Cell"
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var updateDateLabel: UILabel!

    
    func configure(issuesItems: Issue, updateDate: String) {
        titleLable.text = issuesItems.title
        updateDateLabel.text = updateDate
    }
    func IconViewConfigure(imageView: UIImage) {
        iconView.image = imageView
    }

}
