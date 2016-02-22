//
//  Overlay.swift
//  SwiftSideMenu
//
//  Created by Tetsuro Higuchi on 2/21/16.
//  Copyright © 2016 wistail. All rights reserved.
//

import UIKit

class Overlay: UIView, UIGestureRecognizerDelegate {
    private var swipeRecognizer: UISwipeGestureRecognizer?
    private var tapRecognizer: UITapGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        hidden = true
        alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() -> Overlay {
        alpha = 1
        return self
    }
    
    func hide() -> Overlay {
        alpha = 0
        return self
    }
    
    func enableSwipeRecognizer(direction: UISwipeGestureRecognizerDirection, target: AnyObject, action: Selector) -> Overlay {
        if swipeRecognizer != nil { disableSwipeRecognizer() }
        swipeRecognizer = UISwipeGestureRecognizer(target: target, action: action)
        swipeRecognizer!.direction = direction
        addGestureRecognizer(swipeRecognizer!)
        return self
    }
    
    func disableSwipeRecognizer() -> Overlay {
        guard let swipeRecognizer = swipeRecognizer else { return self }
        removeGestureRecognizer(swipeRecognizer)
        self.swipeRecognizer = nil
        return self
    }
    
    func enableTapRecognizer(target: AnyObject, action: Selector) -> Overlay {
        if tapRecognizer != nil { disableTapRecognizer() }
        tapRecognizer = UITapGestureRecognizer(target: target, action: action)
        tapRecognizer?.delegate = self
        addGestureRecognizer(tapRecognizer!)
        return self
    }
    
    func disableTapRecognizer() -> Overlay {
        guard let tapRecognizer = tapRecognizer else { return self }
        removeGestureRecognizer(tapRecognizer)
        self.tapRecognizer = nil
        return self
    }
    
    private func setup() {
        self.backgroundColor = UIColor(hue:0, saturation:0, brightness:0.02, alpha:0.8)
    }

    static func view() -> Overlay {
        let frame = UIScreen.mainScreen().bounds
        return Overlay(frame: frame)
    }
}
