//
//  KeyboardLock.swift
//  KeyboardLock
//
//  Created by Nathan Fiscaletti on 3/20/19.
//  Copyright © 2019 Nathan Fiscaletti. All rights reserved.
//

import Foundation
import UIKit

public class KeyboardLock
{
    // Used to control how the lock
    // effects the view.
    //
    // BottomConstraint:
    //     The bottom constraint will be moved up
    //     based on the height of the keyboard
    //     once it's displayed.
    //
    // HeightConstraint:
    //     The height of the constraint will be
    //     shortened based on the height of the
    //     keyboard once it's displayed.
    //
    // FrameOrigin:
    //     The Y origin point of the view will be
    //     moved up based on the height of the
    //     keyboard once it's displayed.
    //
    public enum LockType
    {
        case BottomConstraint
        case HeightConstraint
        case FrameOrigin
    }
    
    /// The height of the keyboard.
    /// Loaded in when the keyboard is about to be displayed.
    ///
    private var keyboardHeight:CGFloat = 0.0
    
    /// The view to modify based on the keyboard.
    ///
    private var view:UIView
    
    /// The LockType controlling the behavior of the lock.
    ///
    private var lockType:LockType
    
    /// The constraint to apply the LockType behavior to.
    ///
    private var constraint:NSLayoutConstraint? = nil
    
    /// Stored property of whether or not keyboard is active.
    ///
    private var keyboardActive:Bool = false
    
    /// The original value for the modified portion of the view.
    ///
    private var originalValue: CGFloat = 0;
    
    /// Stored observers.
    ///
    private var keyboardWillShowObserver : NSObjectProtocol? = nil
    private var keyboardWillHideObserver : NSObjectProtocol? = nil
    
    /// Initialize the KeyboardLock
    ///
    /// - Parameters:
    ///     - view: The view to modify based on the keyboard.
    ///     - type: The LockType controlling the behavior of the lock.
    ///
    public init(
        withView                  view: UIView,
        andLockType               type: LockType
    ) {
        self.view = view
        self.lockType = type
        
        switch (type) {
        case .BottomConstraint :
            if let bottom = self.getBottomConstraint() {
                self.originalValue = bottom.constant
            } else {
                self.originalValue = 0
                NSLog("KeyboardLock: Failed to find bottom constraint.")
            }
            break
            
        case .HeightConstraint :
            if let height = self.getHeightConstraint() {
                self.originalValue = height.constant
            } else {
                self.originalValue = 0
                NSLog("KeyboardLock: Failed to find height constraint.")
            }
            break;
            
        case .FrameOrigin :
            self.originalValue = view.frame.origin.y
            break;
        }
    }
    
    /// Initialize the KeyboardLock
    ///
    /// - Parameters:
    ///     - view      : The view to modify based on the keyboard.
    ///     - type      : The LockType controlling the behavior of the lock.
    ///     - constraint: The constraint to apply the LockType behavior to.
    ///
    public init(
        withView                  view: UIView,
        andLockType               type: LockType,
        andConstraint       constraint: NSLayoutConstraint
        ) {
        self.view = view
        self.lockType = type
        self.constraint = constraint
        
        if (type == .BottomConstraint || type == .HeightConstraint) {
            self.originalValue = constraint.constant
        } else {
            self.originalValue = view.frame.origin.y
        }
    }
    
    /// Lock the view to the keyboard using
    /// the specified lock type.
    ///
    public func lock()
    {
        self.keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: { notification in
                let keyboardSize: CGSize? = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
                self.keyboardHeight = (keyboardSize?.height)!
                self.keyboardActive = true
                
                UIView.animate(withDuration: 0.3) {
                    switch(self.lockType) {
                    case .HeightConstraint :
                        self.updateHeightConstraint(value: self.originalValue - (self.keyboardHeight - (self.view.window?.safeAreaInsets)!.bottom))
                        break;
                        
                        
                    case .BottomConstraint :
                        self.updateBottomConstraint(value: self.originalValue - (self.keyboardHeight - (self.view.window?.safeAreaInsets)!.bottom))
                        break;
                        
                    case .FrameOrigin :
                        self.updateFrameOrigin(value: self.originalValue - (self.keyboardHeight - (self.view.window?.safeAreaInsets)!.bottom))
                        break;
                    }
                    
                    self.view.superview?.layoutIfNeeded()    
                }
        }
        )
        
        self.keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: { notification in
                self.keyboardActive = false
                UIView.animate(withDuration: 0.3) {
                    switch(self.lockType) {
                    case .HeightConstraint :
                        self.updateHeightConstraint(value: self.originalValue)
                        break;
                        
                        
                    case .BottomConstraint :
                        self.updateBottomConstraint(value: self.originalValue)
                        break;
                        
                    case .FrameOrigin :
                        self.updateFrameOrigin(value: self.originalValue)
                        break;
                    }
                    
                    self.view.superview?.layoutIfNeeded()
                }
        }
        )
    }
    
    /// Unlock the view from the keyboard.
    ///
    public func unlock()
    {
        if (keyboardActive)
        {
            UIView.animate(withDuration: 0.3) {
                switch(self.lockType) {
                case .HeightConstraint :
                    self.updateHeightConstraint(value: self.originalValue)
                    break;
                    
                    
                case .BottomConstraint :
                    self.updateBottomConstraint(value: self.originalValue)
                    break;
                    
                case .FrameOrigin :
                    self.updateFrameOrigin(value: self.originalValue)
                    break;
                }
                
                self.view.superview?.layoutIfNeeded()
            }
        }
        
        if let _ = self.keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(self.keyboardWillShowObserver!)
        }
        
        if let _ = self.keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(self.keyboardWillHideObserver!)
        }
    }
    
    /// Update the Height Constraint.
    ///
    /// If no constraint has been manually applied, one will be
    /// searched for that matches the required criteria.
    ///
    /// - Parameters
    ///     - add: The amount to add to the constraint constant.
    ///
    private func updateHeightConstraint(value: CGFloat)
    {
        if let constraint = self.constraint {
            constraint.constant = value
            return
        }
        
        for i in self.view.constraints.indices {
            let constraint = self.view.constraints[i]
            if constraint.firstAttribute == .height && constraint.relation == .equal {
                self.view.constraints[i].constant = value
                return
            }
        }
        
        NSLog("KeyBoardLock: Failed to find height constraint.")
    }
    
    /// Update the Bottom Constraint.
    ///
    /// If no constraint has been manually applied, one will be
    /// searched for that matches the required criteria.
    ///
    /// - Parameters
    ///     - add: The amount to add to the constraint constant.
    ///
    private func updateBottomConstraint(value: CGFloat)
    {
        if let constraint = self.constraint {
            constraint.constant = value
            return
        }
        
        for i in self.view.superview?.constraints.indices
            ?? Range(NSRange(location: 0, length: 0))! {
                if let constraint = self.view.superview?.constraints[i] {
                    if
                        constraint.firstItem as? UIView == self.view &&
                            constraint.firstAttribute == .bottom &&
                            constraint.relation == .equal
                    {
                        self.view.superview?.constraints[i].constant = value
                        return
                    }
                }
        }
        
        NSLog("KeyBoardLock: Failed to find bottom constraint.")
    }
    
    /// Retrieve the bottom constraint
    ///
    private func getBottomConstraint() -> NSLayoutConstraint?
    {
        for i in self.view.superview?.constraints.indices
            ?? Range(NSRange(location: 0, length: 0))! {
                if let constraint = self.view.superview?.constraints[i] {
                    if
                        constraint.firstItem as? UIView == self.view &&
                            constraint.firstAttribute == .bottom &&
                            constraint.relation == .equal
                    {
                        return constraint
                    }
                }
        }
        
        return nil
    }
    
    /// Retrieve the height constraint
    ///
    private func getHeightConstraint() -> NSLayoutConstraint?
    {
        for i in self.view.constraints.indices {
            let constraint = self.view.constraints[i]
            if constraint.firstAttribute == .height && constraint.relation == .equal {
                return constraint
            }
        }
        
        return nil
    }
    
    /// Update the Frame origin.
    ///
    /// - Parameters
    ///     - add: The amount to add to the value.
    ///
    private func updateFrameOrigin(value: CGFloat)
    {
        var frame = self.view.frame
        frame.origin.y = value
        self.view.frame = frame
    }
}
