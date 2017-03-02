//
//  SimpleSwiftTest.swift
//  Testable Swift
//
//  Created by Jim Puls on 10/29/14.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

import UIKit
import XCTest


extension XCTestCase {
    func tester(_ file : String = #file, _ line : Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(_ file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}

class SimpleSwiftTest: KIFTestCase {
    
    func testGreenCellWithIdentifier() {
        tester().tapView(withAccessibilityIdentifier: "Green Cell Identifier")
        tester().waitForView(withAccessibilityIdentifier: "Selected: Green Color")
    }
    
    func testBlueCellWithLabel() {
        tester().tapView(withAccessibilityLabel: "Blue Cell Label")
        tester().waitForView(withAccessibilityLabel: "Selected: Blue Color")

    }
}
