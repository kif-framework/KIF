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
        uiViewTestActor.usingLabel("Tap Me").tap()
        uiTestActor.waitForView(withAccessibilityLabel: "Done")
        uiTestActor.waitForView(withAccessibilityIdentifier: "tapmeid")
        uiViewTestActor.usingLabel("Done").waitForView()
    }
}

private extension XCTestCase {
    var uiViewTestActor: KIFUIViewTestActor {
        KIFUIViewTestActor(inFile: #file, atLine: #line, delegate: self)
    }
    var uiTestActor: KIFUITestActor {
        KIFUITestActor(inFile: #file, atLine: #line, delegate: self)
    }

}
