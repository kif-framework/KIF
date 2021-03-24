//
//  SPMIntegrationTests.swift
//  SPMIntegrationTests
//
//  Created by Pablo Bartolome on 24/3/21.
//

import XCTest
import KIF
@testable import SPMIntegration

class SPM_IntegrationTests: KIFTestCase {
    func testGreenCellWithIdentifier() {
        viewTester().usingLabel("Tap Me").tap()
        viewTester().usingLabel("Done").waitForView()
    }
}

private extension XCTestCase {
    func viewTester(_ file : String = #file, _ line : Int = #line) -> KIFUIViewTestActor {
        return KIFUIViewTestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(_ file : String = #file, _ line : Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}
