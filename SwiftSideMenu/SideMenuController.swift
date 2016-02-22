//
//  SideMenuController.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/20/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

public struct SideMenu {
    public enum DisplayOrder {
        case Front
        case Back
    }
    
    public enum Position {
        case Left
        case Right
    }
}

public class SideMenuController: UIViewController {
    // MARK: - Customizable settings
    public static var displayOrder: SideMenu.DisplayOrder = .Back
    public static var revealPercentage: CGFloat = 0.7
    public static var revealAnimationDuration: NSTimeInterval = 0.3
    public static var hideAnimationDuration: NSTimeInterval = 0.2

    // MARK: - Set from IB
    public var identifierForCenter: String = "CenterPane"
    public var identifierForLeft: String?
    public var identifierForRight: String?

    
    public var centerViewController: UIViewController? {
        didSet { didSetCenterController() }
    }
    public var leftSideViewController: UIViewController? {
        didSet { didSetSideController(leftSideViewController, position:.Left) }
    }
    public var rightSideViewController: UIViewController? {
        didSet { didSetSideController(rightSideViewController, position:.Right) }
    }
    private var screenSize = UIScreen.mainScreen().bounds.size
    private var displayOrder: SideMenu.DisplayOrder = SideMenuController.displayOrder
    private var centerContainer: CenterPaneContainer!
    private var sideContainers: (left:SidePaneContainer?, right:SidePaneContainer?) = (nil, nil)
    private var statusBarView: StatusBarSpacer!
    private var landscapeOrientation: Bool { return screenSize.width > screenSize.height }
    
    // MARK: - View lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addControllersFromSegue()
    }
    
    public func toggleSideMenu(position: SideMenu.Position = .Left) {
        if displayOrder == .Back {
            centerContainer.toggle(position)
        } else if position == .Left {
            sideContainers.left?.toggle()
        } else if position == .Right {
            sideContainers.right?.toggle()
        }
    }
    
    // < iOS 8
    override public func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if toInterfaceOrientation == .Portrait || toInterfaceOrientation == .PortraitUpsideDown {
            screenSize = UIScreen.mainScreen().bounds.size
        } else {
            screenSize = CGSizeMake(screenSize.height, screenSize.width)
        }
        UIView.animateWithDuration(duration) { self.updateFramesOnRotate() }
    }
    
    //  >= iOS 8
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        screenSize = size
        coordinator.animateAlongsideTransition({_ in self.updateFramesOnRotate() }, completion: nil)
    }
    
    private func updateFramesOnRotate() {
        centerContainer?.screenSize = screenSize
        sideContainers.left?.screenSize = screenSize
        sideContainers.right?.screenSize = screenSize
        self.view.layoutIfNeeded()
    }
    
    func addController(controller: UIViewController, identifier: String) {
        switch(identifier) {
        case identifierForCenter: centerViewController    = controller
        case identifierForLeft! : leftSideViewController  = controller
        case identifierForRight!: rightSideViewController = controller
        default: break
        }
    }
    
    // MARK: - Private Methods
    private func setup(){
        displayOrder = SideMenuController.displayOrder
        statusBarView = StatusBarSpacer.view()
        self.view.addSubview(statusBarView)
        self.view.bringSubviewToFront(statusBarView)
    }
    
    private func addControllersFromSegue() {
        performSegueWithIdentifier(identifierForCenter, sender: nil)
        if let identifierForLeft = identifierForLeft {
            performSegueWithIdentifier(identifierForLeft, sender: nil)
        }
        if let identifierForRight = identifierForRight {
            performSegueWithIdentifier(identifierForRight, sender: nil)
        }
    }
    
    private func didSetCenterController() {
        guard let controller = centerViewController else { return }

        if centerContainer == nil {
            centerContainer = CenterPaneContainer.view()
        }
        centerContainer.addSubview(controller.view)
        centerContainer.delegate = self
        view.addSubview(centerContainer)
        addChildViewController(controller)
        controller.didMoveToParentViewController(self)
    }

    private func didSetSideController(controller: UIViewController?, position: SideMenu.Position) {
        guard let controller = controller else { return }
        
        addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        
        let container = createSideContainer(controller.view, position: position)
        if position == .Left {
            centerContainer.leftSideContainer = container
            sideContainers = (left:container, right:sideContainers.right)
        } else {
            centerContainer.rightSideContainer = container
            sideContainers = (left:sideContainers.left, right:container)
        }
    }
    
    private func createSideContainer(contentView: UIView, position: SideMenu.Position) -> SidePaneContainer {
        let sideContainer = SidePaneContainer.view(position, order: displayOrder)
        sideContainer.centerContainer = centerContainer
        sideContainer.delegate = self
        sideContainer.addSubview(contentView)
        sideContainer.hidden = displayOrder == .Front
        
        view.addSubview(sideContainer)
        
        if displayOrder == .Back {
            centerContainer.enablePanGesture()
            view.sendSubviewToBack(sideContainer)
        } else {
            centerContainer.enableSwipeRecognizer(position.flickDirectionToShow, target: sideContainer, action: "show")
            sideContainer.enablePanGesture()
            view.bringSubviewToFront(sideContainer)
        }
        
        if displayOrder == .Front {
            let overlay = Overlay.view()
            view.insertSubview(overlay, aboveSubview: centerContainer)
            sideContainer.overlay = overlay
        }
        return sideContainer
    }
}

extension SideMenuController: SidePaneContainerDelegate {
    func didShowSidePane(sideContainer: SidePaneContainer) {
        centerViewController?.view.userInteractionEnabled = false
        if !landscapeOrientation {
            statusBarView.alpha = 1
        }
    }
    
    func didHideSidePane(sideContainer: SidePaneContainer) {
        centerViewController?.view.userInteractionEnabled = true
        if !landscapeOrientation {
            statusBarView.alpha = 0
        }
    }
}

extension SideMenu.Position {
    var flickDirectionToHide:UISwipeGestureRecognizerDirection {
        switch(self) {
        case .Left:  return .Left
        case .Right: return .Right
        }
    }
    
    var flickDirectionToShow:UISwipeGestureRecognizerDirection {
        switch(self) {
        case .Left:  return .Right
        case .Right: return .Left
        }
    }
}
