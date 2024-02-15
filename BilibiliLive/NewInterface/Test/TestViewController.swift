//
//  TestViewController.swift
//  StudyAppleTVUI
//
//  Created by Chance Zhang on 2024/1/29.
//

import UIKit

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .system)
        button.setTitle("TEST VC", for: .normal)
        button.frame = CGRectMake(0, 0, 300, 88)
        button.center = CGPointMake(view.bounds.size.width / 2,
                                    view.bounds.size.height / 2)
        view.addSubview(button)
    }
}
