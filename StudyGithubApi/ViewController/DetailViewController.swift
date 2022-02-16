//
//  DetailViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var didTapUrllabel: UIButton!

//    var title: String?
    var detail:[Issue] = []
    var issue: Issue?
    var selectedText: Issue!
    override func viewDidLoad() {
        super.viewDidLoad()
//        detail.forEach({print($0.body)})
        titleLabel.text = selectedText.title
        bodyLabel.text = selectedText.body
        didTapUrllabel.setTitle("\(selectedText.url)", for: .normal)
    }

    @IBAction func didTapUrlButton(_ sender: Any) {
        let url = URL(string: "\(selectedText.url)")
        let safariVc = SFSafariViewController(url: url!)
         present(safariVc, animated: true, completion: nil)
        }
    }

