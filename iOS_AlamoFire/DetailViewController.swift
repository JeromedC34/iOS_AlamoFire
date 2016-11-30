//
//  DetailViewController.swift
//  iOS_AlamoFire
//
//  Created by imac on 28/11/2016.
//  Copyright © 2016 imac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailBodyTextView: UITextView!
    func configureView() {
        // Update the user interface for the detail item.
        if let label = self.detailDescriptionLabel {
            if let detail = self.detailItem {
                label.text = detail.title
                detailBodyTextView.text = detail.body
            } else {
                label.text = ""
                detailBodyTextView.text = ""
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var detailItem: Post? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
}
