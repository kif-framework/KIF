//
//  SwiftUIViewControllerFactory.swift
//  KIF
//
//  Created by Bartłomiej Włodarczak on 03/02/2025.
//

import UIKit

@MainActor final class SwiftUIViewControllerFactory: NSObject {
    private override init() {}
    
    @objc static func makeBasicSwiftUIViewController() -> UIViewController {
        SwiftUIViewController(content: SwiftUIBasicView())
    }
}
