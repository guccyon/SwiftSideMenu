//
//  PaneContainer.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/22/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class PaneContainer: UIView {
    var transitionInProgress: Bool = false
    var flickVelocity: CGFloat = 0
    private var panRecognizer: UIPanGestureRecognizer?
    private var tapRecognizer: UITapGestureRecognizer?
    private var swipeRecognizers:(left: UISwipeGestureRecognizer?, right: UISwipeGestureRecognizer?) = (nil, nil)
    
    func durationToShow() -> NSTimeInterval {
        return durationToAnimate(SideMenuController.revealAnimationDuration)
    }
    
    func durationToHide() -> NSTimeInterval {
        return durationToAnimate(SideMenuController.hideAnimationDuration)
    }

    func animateToMove(duration: NSTimeInterval, position: CGPoint, completion: (Void -> Void)?) {
        UIView.animateWithDuration(duration,
            animations: { self.frame.origin = position },
            completion: {_ in completion?() })
    }
    
    private func durationToAnimate(duration: NSTimeInterval) -> NSTimeInterval {
        guard abs(flickVelocity) > 0 else { return duration }
        let newDuration = NSTimeInterval (frame.size.width / abs(flickVelocity))
        flickVelocity = 0
        return newDuration < duration ? newDuration : duration
    }

    func enableSwipeRecognizer(direction: UISwipeGestureRecognizerDirection, target: AnyObject, action: Selector) -> UISwipeGestureRecognizer {
        let swipeRecognizer = UISwipeGestureRecognizer(target: target, action: action)
        swipeRecognizer.direction = direction
        addGestureRecognizer(swipeRecognizer)
        
        switch(direction) {
        case UISwipeGestureRecognizerDirection.Left:
            swipeRecognizers = (left: swipeRecognizer, right: swipeRecognizers.right)
        case UISwipeGestureRecognizerDirection.Right:
            swipeRecognizers = (left: swipeRecognizers.left, right: swipeRecognizer)
        default: break
        }
        return swipeRecognizer
    }
    
    func disableSwipeRecognizer(direction: UISwipeGestureRecognizerDirection) {
        switch(direction) {
        case UISwipeGestureRecognizerDirection.Left:
            guard let recognizer = swipeRecognizers.left else { return }
            removeGestureRecognizer(recognizer)
            swipeRecognizers = (left: nil, right: swipeRecognizers.right)
        case UISwipeGestureRecognizerDirection.Right:
            guard let recognizer = swipeRecognizers.right else { return }
            removeGestureRecognizer(recognizer)
            swipeRecognizers = (left: swipeRecognizers.left, right: nil)
        default: break
        }
    }
    
    func enablePanRecognizer(target: AnyObject, action: Selector) -> UIPanGestureRecognizer {
        guard panRecognizer == nil else { return panRecognizer! }
        panRecognizer = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(panRecognizer!)
        return panRecognizer!
    }
    
    func enableTapRecognizer(target: AnyObject, action: Selector) -> UITapGestureRecognizer {
        guard tapRecognizer == nil else { return tapRecognizer! }
        tapRecognizer = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapRecognizer!)
        return tapRecognizer!
    }
    
    func disableTapRecognizer() {
        guard let tapRecognizer = tapRecognizer else { return }
        removeGestureRecognizer(tapRecognizer)
        self.tapRecognizer = nil
    }
    
    func disablePanRecognizer() {
        guard let panRecognizer = panRecognizer else { return }
        removeGestureRecognizer(panRecognizer)
        self.panRecognizer = nil
    }
}
