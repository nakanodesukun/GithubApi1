//
//  CustomCell.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var updateDateLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    // 処理
    func configure(item: Issue) {
        titleLable.text = item.title
        updateDateLabel.text = item.updatedAt
    }

}
