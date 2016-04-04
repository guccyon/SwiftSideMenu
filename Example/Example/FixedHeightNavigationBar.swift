//
//  FixedHeightNavigationBar.swift
//  Example
//
//  Created by Tetsuro Higuchi on 4/4/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class FixedHeightNavigationBar: UINavigationBar {
    override func sizeThatFits(size: CGSize) -> CGSize {
        if UIApplication.sharedApplication().statusBarHidden {
            var newSize = super.sizeThatFits(size)
            newSize.height = 64
            return newSize
        } else {
            return super.sizeThatFits(size)
        }
    }
}