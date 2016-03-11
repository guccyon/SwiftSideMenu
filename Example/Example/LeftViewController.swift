//
//  LeftViewController.swift
//  Example
//
//  Created by Tetsuro Higuchi on 3/11/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class LeftViewController: UITableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("LeftViewController#viewWillAppear")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("LeftViewController#viewDidAppear")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("LeftViewController#viewWillDisappear")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("LeftViewController#viewDidDisappear")
    }
}
