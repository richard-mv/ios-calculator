//
//  ViewController.swift
//  Calculator
//
//  Created by Richard Mejía on 6/15/17.
//  Copyright © 2017 Richard Mejía. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var sequenceDisplay: UILabel!
    
    var userIsTyping = false
    
    var dotIsTyped = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if (userIsTyping) {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }else {
            display.text = digit
            userIsTyping = true
        }
        if (!brain.resultIsPending) {
            brain.clearSequence()
        }
    }
    
    @IBAction func touchDot(_ sender: UIButton) {
        if (!dotIsTyped) {
            touchDigit(sender)
            dotIsTyped = true
        }
    }
    var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
            dotIsTyped = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        sequenceDisplay.text = brain.description
    }

}

