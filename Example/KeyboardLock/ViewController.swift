//
//  ViewController.swift
//  KeyboardLock
//
//  Created by nathan-fiscaletti on 03/21/2019.
//  Copyright (c) 2019 nathan-fiscaletti. All rights reserved.
//

import UIKit
import KeyboardLock

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    private var lock:KeyboardLock? = nil
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lockTypePicker: UIPickerView!
    @IBOutlet weak var testTextBox: UITextField!
    
    /// We only keep track of these in order to
    /// change their priority, since in this demo
    /// view we have the ability to display both
    /// a HeightConstraint and a BottomConstraint lock.
    ///
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    /// When you tap done, dismiss the keyboard.
    ///
    @IBAction func doneTapped(_ sender: Any) {
        testTextBox.resignFirstResponder()
    }
    
    /// Set up the lockTypePicker
    /// and set the default lock
    /// type to BottomConstraint.
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockTypePicker.delegate = self
        lockTypePicker.dataSource = self
        
        self.lock = KeyboardLock(
            withView: containerView,
            andLockType: .BottomConstraint
        )
        
        if let lock = self.lock {
            lock.lock()
        }
    }
    
    /// When the lock type is changed, update the lock
    ///
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        /// First unlock any active lock.
        ///
        self.lock?.unlock()
        
        if (row == 0) {
            
            NSLog("Set to .BottomConstraint")
            
            // Set the height based on the device type
            // since iPhone X has bottom margins.
            heightConstraint.constant = (self.view.window?.frame)!.height - (
                (self.view.window?.safeAreaInsets)!.bottom + (self.view.window?.safeAreaInsets)!.top
            )
            
            /// Update the priority on our height
            /// and bottom constraints so that
            /// they don't interfere with eachother.
            ///
            bottomConstraint.priority = UILayoutPriority(999)
            heightConstraint.priority = UILayoutPriority(998)
            
            /// Creat the lock.
            ///
            self.lock = KeyboardLock(
                withView: containerView,
                andLockType: .BottomConstraint
            )

        } else if (row == 1) {
            
            NSLog("Set to .HeightConstraint")
            
            // Set the height based on the device type
            // since iPhone X has bottom margins.
            heightConstraint.constant = (self.view.window?.frame)!.height - (
                (self.view.window?.safeAreaInsets)!.bottom + (self.view.window?.safeAreaInsets)!.top
            )
            
            /// Update the priority on our height
            /// and bottom constraints so that
            /// they don't interfere with eachother.
            ///
            bottomConstraint.priority = UILayoutPriority(998)
            heightConstraint.priority = UILayoutPriority(999)
            
            /// Create the lock.
            ///
            self.lock = KeyboardLock(
                withView: containerView,
                andLockType: .HeightConstraint
            )
        } else if (row == 2) {
            
            NSLog("Set to .FrameOrigin")
            
            /// Update the priority on our height
            /// and bottom constraints so that
            /// they don't interfere with eachother.
            ///
            bottomConstraint.priority = UILayoutPriority(999)
            heightConstraint.priority = UILayoutPriority(998)
            
            // Set the height based on the device type
            // since iPhone X has bottom margins.
            heightConstraint.constant = (self.view.window?.frame)!.height - (
                (self.view.window?.safeAreaInsets)!.bottom + (self.view.window?.safeAreaInsets)!.top
            )
            
            /// Create the lock.
            self.lock = KeyboardLock(
                withView: containerView,
                andLockType: .FrameOrigin
            )
        }
        
        /// Lock the container view to the keyboard.
        ///
        self.lock?.lock()
        
        /// Hide any active keyboard when you change the lock type.
        ///
        self.testTextBox.resignFirstResponder()
    }
    
    /// Utility functions for controlling the LockTypePicker
    ///
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0) {
            return "Bottom Constraint"
        } else if (row == 1) {
            return "Height Constraint"
        } else if (row == 2) {
            return "FrameOrigin"
        }
        
        return ""
    }
}

