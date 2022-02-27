//
//  DetailViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.

import UIKit
import SafariServices

final class DetailViewController: UIViewController{

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var didTapUrllabel: UIButton!
    
    var selectedIssue: Issue?
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedIssue?.title
        bodyLabel.text = selectedIssue?.body
        dateLabel.text = selectedDate
//        didTapUrllabel.setTitle("\(describing: selectedIssue!.url)", for: .normal)

    }

    private func giveItem(item:Issue, detaText: String) {
        titleLabel.text = item.title
        bodyLabel.text = item.body
        dateLabel.text = selectedDate
//        didTapUrllabel.setTitle("\(String(describing: selectedIssue!.url))", for: .normal)
    }
    
    @IBAction func didTapUrlButton(_ sender: Any) {
        guard let url = selectedIssue?.url else {
            return
        }
        let safariVc = SFSafariViewController(url: url)
        present(safariVc, animated: true, completion: nil)
    }

}


