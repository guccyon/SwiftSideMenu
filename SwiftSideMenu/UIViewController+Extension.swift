//
//  UIViewController+Extension.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/22/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import Foundation

extension UIViewController {
    public func sideMenuController() -> SideMenuController? {
        return findSideMenuControllerRecursively(self)
    }
    
    private func findSideMenuControllerRecursively(controller : UIViewController) -> SideMenuController? {
        if let sideMenu = controller as? SideMenuController {
            return sideMenu
        } else if let parent = controller.parentViewController {
            return findSideMenuControllerRecursively(parent)
        } else {
            return nil
        }
    }
}
