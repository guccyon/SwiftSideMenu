//
//  SidePane.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/20/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

protocol SidePaneContainerDelegate: class {
    func didShowSidePane(sidePane: SidePaneContainer)
    func didHideSidePane(sidePane: SidePaneContainer)
}


class SidePaneContainer: PaneContainer, UIGestureRecognizerDelegate {
    var position: SideMenu.Position = .Left
    
    weak var centerContainer: CenterPaneContainer!
    weak var overlay: Overlay?
    weak var delegate: SidePaneContainerDelegate?
    var screenSize = UIScreen.mainScreen().bounds.size {
        didSet { updateFrame() }
    }
    
    private var order: SideMenu.DisplayOrder = SideMenuController.displayOrder
    private var percentage = SideMenuController.revealPercentage
    private var originalPosition: CGPoint {
        let x = position == .Left ? -CGRectGetWidth(frame) : screenSize.width
        return CGPoint(x: x, y: frame.origin.y)
    }
    private var revealPosition: CGPoint {
        let x = position == .Left ?
            CGRectGetMaxX(frame) :
            CGRectGetMaxX(centerContainer.frame) - CGRectGetWidth(frame)
        return CGPoint(x: x, y: frame.origin.y)
    }

    convenience init(position: SideMenu.Position, order: SideMenu.DisplayOrder) {
        self.init(frame: CGRect())
        self.position = position
        self.order = order
        self.clipsToBounds = true
        updateFrame()
    }
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        view.frame = bounds
    }
    
    func toggle() {
        guard !transitionInProgress else { return }
        hidden ? show() : hide()
    }
    
    func show() {
        prepareToShow()
        transitionInProgress = true
        UIView.animateWithDuration(durationToShow(),
            animations: {
                self.frame.origin = self.revealPosition
                self.overlay?.show()
            },
            completion: {_ in
                self.overlay?.enableTapRecognizer(self, action: "hide")
                self.overlay?.enableSwipeRecognizer(self.position.flickDirectionToHide, target: self, action: "hide")
                self.transitionInProgress = false
                self.delegate?.didShowSidePane(self)
        })
    }

    func hide() {
        guard !hidden else { return }
        
        transitionInProgress = true
        UIView.animateWithDuration(durationToHide(),
            animations: {
                self.frame.origin = self.originalPosition
                self.overlay?.hide()
            },
            completion: {_ in
                self.overlay?.disableTapRecognizer()
                self.overlay?.disableSwipeRecognizer()
                self.overlay?.hidden = true
                self.hidden = true
                self.transitionInProgress = false
                self.delegate?.didHideSidePane(self)
        })
    }

    func enablePanGesture() {
        enablePanRecognizer(self, action: "handlePanGesture:")
    }
    
    func handlePanGesture(recognizer : UIPanGestureRecognizer){
        flickVelocity = recognizer.velocityInView(recognizer.view).x
        
        switch recognizer.state {
        case .Began:
            prepareToShow()
        case .Changed:
            let sidePanelWidth = CGRectGetWidth(frame)
            let translation = recognizer.translationInView(superview?.superview).x
            let xPoint: CGFloat = center.x + translation + (position == .Left ? 1 : -1) * sidePanelWidth / 2
            var alpha: CGFloat
            
            if position == .Left {
                if xPoint <= 0 || xPoint > CGRectGetWidth(frame) { return }
                alpha = xPoint / CGRectGetWidth(frame)
            } else {
                if xPoint <= screenSize.width - sidePanelWidth || xPoint >= screenSize.width { return }
                alpha = 1 - (xPoint - (screenSize.width - sidePanelWidth)) / sidePanelWidth
            }
            
            self.overlay?.alpha = alpha
            
            center.x = center.x + translation
            recognizer.setTranslation(CGPointZero, inView: superview?.superview)
        default:
            if shouldClose(flickVelocity > 0) {
                hide()
            } else {
                show()
            }
        }
    }
    
    private func shouldClose(swipeLeftToRight: Bool) -> Bool {
        if position == .Left {
            return !swipeLeftToRight && CGRectGetMaxX(frame) < CGRectGetWidth(frame)
        } else {
            return swipeLeftToRight  && CGRectGetMinX(frame) > (screenSize.width - CGRectGetWidth(frame))
        }
    }
    
    private func prepareToShow() {
        hidden = false
        overlay?.hidden = false
    }
    
    private func updateFrame() {
        self.frame = CGRectMake(positionX(), 0, calcWidth(), screenSize.height)
    }
    
    private func calcWidth() -> CGFloat {
        return percentage * min(screenSize.width, screenSize.height)
    }
    
    private func positionX() -> CGFloat {
        if order == .Back  {
            return position == .Left ? 0 : screenSize.width - calcWidth()
        } else {
            return position == .Left ? -calcWidth() : screenSize.width
        }
    }
    
    static func view(position: SideMenu.Position = .Left, order: SideMenu.DisplayOrder = .Back) -> SidePaneContainer {
        return SidePaneContainer(position: position, order: order)
    }
}
