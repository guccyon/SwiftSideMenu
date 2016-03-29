//
//  CenterPaneContainer.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/21/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class CenterPaneContainer: PaneContainer, UIGestureRecognizerDelegate {
    weak var leftSideContainer: SidePaneContainer?
    weak var rightSideContainer: SidePaneContainer?
    weak var visibleContainer: SidePaneContainer?
    weak var delegate: SidePaneContainerDelegate?
    var screenSize = UIScreen.mainScreen().bounds.size {
        didSet { updateFrame() }
    }

    private var navigationBar: UINavigationBar?
    private var sidePaneVisible: Bool = false
    private let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height > 0 ?
        UIApplication.sharedApplication().statusBarFrame.size.height : 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        updateFrame()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        view.frame = bounds
    }
        
    func toggle(position: SideMenu.Position) {
        guard !transitionInProgress else { return }
        sidePaneVisible ? hideSidePane() : showSidePane(position)
    }
    
    func showSidePane(position: SideMenu.Position, skipDelegate: Bool = false) {
        transitionInProgress = true
        showShadow()
        if visibleContainer == nil {
            visibleContainer = position == .Left ? leftSideContainer : rightSideContainer
            prepareToShow()
        }

        guard let visibleContainer = visibleContainer else { return }
        moveTo(revealPosition(position), duration: durationToShow() ) {
            self.transitionInProgress = false
            self.enableTapRecognizer(self, action: #selector(CenterPaneContainer.hideSidePane))
            self.sidePaneVisible = true
            if skipDelegate { return }
            self.delegate?.didShowSidePane(visibleContainer)
        }
    }
    
    func hideSidePane() {
        guard let visibleContainer = visibleContainer else { return }
        delegate?.willHideSidePane(visibleContainer)
        transitionInProgress = true
        returnToOriginal(durationToHide() ) {
            self.hideShadow()
            self.disableTapRecognizer()
            self.transitionInProgress = false
            self.sidePaneVisible = false
            self.delegate?.didHideSidePane(visibleContainer)
            self.visibleContainer = nil
        }
    }
    
    func enablePanGesture() {
        enablePanRecognizer(self, action: #selector(CenterPaneContainer.handlePanGesture(_:)))
    }

    func handlePanGesture(recognizer : UIPanGestureRecognizer){
        flickVelocity = recognizer.velocityInView(recognizer.view).x
        let leftToRight = flickVelocity > 0
        
        switch(recognizer.state) {
        case .Began:
            guard visibleContainer == nil else { return }
            visibleContainer = leftToRight ? leftSideContainer : rightSideContainer
            prepareToShow()
        case .Changed:
            guard let visibleContainer = visibleContainer else { return }
            let translation = recognizer.translationInView(superview).x
            
            var halfWidth = CGRectGetWidth(frame) / 2
            if visibleContainer.position == .Left {
                halfWidth = -halfWidth
            }

            let xPoint : CGFloat = center.x + translation + halfWidth
            if xPoint < CGRectGetMinX(visibleContainer.frame) || xPoint > CGRectGetMaxX(visibleContainer.frame){
                return
            }
            
            center.x = center.x + translation
            recognizer.setTranslation(CGPointZero, inView: superview)
        default:
            guard let visibleContainer = visibleContainer else { return }
            if shouldOpen(visibleContainer, swipeLeftToRight: leftToRight) {
                showSidePane(visibleContainer.position, skipDelegate: sidePaneVisible)
            } else {
                hideSidePane()
            }
        }
    }
    
    private func prepareToShow() {
        showShadow()
        guard let visibleContainer = visibleContainer else { return }
        superview?.bringSubviewToFront(visibleContainer)
        superview?.bringSubviewToFront(self)
        delegate?.willShowSidePane(visibleContainer)
    }
    
    private func shouldOpen(visibleContainer: SidePaneContainer, swipeLeftToRight: Bool) -> Bool {
        if visibleContainer.position == .Left {
            if swipeLeftToRight {
                return CGRectGetMinX(frame) > CGRectGetWidth(visibleContainer.frame) * 0.2
            } else {
                return CGRectGetMinX(frame) > CGRectGetWidth(visibleContainer.frame) * 0.8
            }
        } else {
            if swipeLeftToRight {
                return CGRectGetMaxX(frame) < CGRectGetMinX(visibleContainer.frame) + 0.2 * CGRectGetWidth(visibleContainer.frame)
            } else {
                return CGRectGetMaxX(frame) < CGRectGetMinX(visibleContainer.frame) + 0.8 * CGRectGetWidth(visibleContainer.frame)
            }
        }
    }
    
    private func moveTo(x: CGFloat, duration: NSTimeInterval, completion: (Void -> Void)?) {
        animateToMove(
            duration,
            position: CGPoint(x: x, y: frame.origin.y),
            completion: completion
        )
    }
    
    private func returnToOriginal(duration: NSTimeInterval, completion: (Void -> Void)?) {
        animateToMove(
            duration,
            position: CGPointZero,
            completion: completion
        )
    }
    
    private func revealPosition(position: SideMenu.Position) -> CGFloat {
        return position == .Left ?
            CGRectGetMaxX(leftSideContainer!.frame) :
            CGRectGetMinX(rightSideContainer!.frame) - CGRectGetWidth(frame)
    }
    
    private func setup() {
        navigationBar = UINavigationBar(frame: CGRectMake(0, 0, frame.width, statusBarHeight))
        addSubview(navigationBar!)
    }
    
    private func updateFrame() {
        self.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height)
        let screenSize = UIScreen.mainScreen().bounds.size
        self.navigationBar?.frame = CGRectMake(0, 0, screenSize.width, statusBarHeight)
    }
    
    private func showShadow() {
        layer.shadowOpacity = 0.8
    }
    
    private func hideShadow() {
        layer.shadowOpacity = 0.0
    }
    
    static func view() -> CenterPaneContainer {
        let screenSize = UIScreen.mainScreen().bounds.size
        return CenterPaneContainer(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
    }
}
