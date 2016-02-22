//
//  StatusBarSpacer.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/21/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class StatusBarSpacer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        self.backgroundColor = UIApplication.sharedApplication().statusBarStyle == UIStatusBarStyle.LightContent ? UIColor.blackColor() : UIColor.whiteColor()
        self.alpha = 0
    }

    static func view() -> StatusBarSpacer {
        let screenSize = UIScreen.mainScreen().bounds
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height > 0 ? UIApplication.sharedApplication().statusBarFrame.size.height : 20
        return StatusBarSpacer(frame: CGRectMake(0, 0, screenSize.width, statusBarHeight))
    }
}
