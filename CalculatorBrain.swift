//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Richard Mejía on 6/17/17.
//  Copyright © 2017 Richard Mejía. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private var sequence = " "
    
    private var cWasCalled = false
    
    private var unaryOperationIsInSequence = false
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals,
        "c" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                sequence += String(symbol)
                unaryOperationIsInSequence = true
            case .unaryOperation(let function):
                if accumulator != nil {
                    if (resultIsPending) {
                        sequence = sequence + symbol + "(" + String(accumulator!) + ")"
                        accumulator = function(accumulator!)
                    }else {
                        if (sequence != " ") {
                            sequence = symbol + "(" + sequence + ")"
                        }else {
                            sequence = symbol + "(" + String(accumulator!) + ")"
                        }
                        accumulator = function(accumulator!)
                    }
                    unaryOperationIsInSequence = true
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    if (!unaryOperationIsInSequence) {
                         sequence += String(accumulator!)
                    }
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    sequence += symbol
                    accumulator = nil
                }
            case .equals:
                if (!unaryOperationIsInSequence) {
                    sequence += String(accumulator!)
                    unaryOperationIsInSequence = true
                }
                performPendingBinaryOperation()
            case .clear:
                clearSequence()
                accumulator = 0
                pendingBinaryOperation = nil
                cWasCalled = true
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        unaryOperationIsInSequence = false
    }
    
    mutating func clearSequence() {
        sequence = " "
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var description: String {
        mutating get {
            if (cWasCalled) {
                cWasCalled = false
                return sequence
            }
            if (resultIsPending) {
                return sequence + "..."
            }
            return sequence + "="
            
        }
    }
    
}
