//
//  File.swift
//  Example
//
//  Created by Tetsuro Higuchi on 3/11/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class RightViewController: UITableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("RightViewController#viewWillAppear")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("RightViewController#viewDidAppear")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("RightViewController#viewWillDisappear")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("RightViewController#viewDidDisappear")
    }
}