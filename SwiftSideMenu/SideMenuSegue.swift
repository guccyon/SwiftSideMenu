//
//  SideMenuSegue.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/22/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import Foundation

@objc(SideMenuSegue)
public class SideMenuSegue : UIStoryboardSegue {
    override public func perform() {
        guard let sideMenuController = sourceViewController as? SideMenuController,
            identifier = identifier else {
            fatalError("This type of segue must only be used from a MenuViewController")
        }
        sideMenuController.addController(destinationViewController, identifier: identifier)
    }
}
