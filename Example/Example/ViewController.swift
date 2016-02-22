//
//  ViewController.swift
//  Example
//
//  Created by Tetsuro Higuchi on 2/20/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit
import SwiftSideMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func toggle(sender: UIBarButtonItem) {
        sideMenuController()?.toggleSideMenu(.Left)
    }
    
    @IBAction func toggleRight(sender: UIBarButtonItem) {
        sideMenuController()?.toggleSideMenu(.Right)
    }
}
