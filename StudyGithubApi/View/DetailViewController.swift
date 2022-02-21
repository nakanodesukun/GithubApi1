//
//  DetailViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var didTapUrllabel: UIButton!

    var selectedText: Issue?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedText?.title
        bodyLabel.text = selectedText?.body
        didTapUrllabel.setTitle("\(selectedText?.url)", for: .normal)
    }
    @IBAction func didTapUrlButton(_ sender: Any) {
        //  gurd文などを使う
        let url = selectedText?.url
        let safariVc = SFSafariViewController(url: url!)
         present(safariVc, animated: true, completion: nil)
        }
    }

