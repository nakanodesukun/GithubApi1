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

    var selectedText: Issue?
    var dateText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedText?.title
        bodyLabel.text = selectedText?.body
        dateLabel.text = dateText
        didTapUrllabel.setTitle("\(String(describing: selectedText?.url))", for: .normal)

    }

    
    @IBAction func didTapUrlButton(_ sender: Any) {
        guard let url = selectedText?.url else {
            return
        }
        let safariVc = SFSafariViewController(url: url)
        present(safariVc, animated: true, completion: nil)
    }
}

