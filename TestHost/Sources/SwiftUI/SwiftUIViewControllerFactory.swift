//
//  SwiftUIViewControllerFactory.swift
//  KIF
//
//  Created by Bartłomiej Włodarczak on 03/02/2025.
//

import UIKit

@MainActor final class SwiftUIViewControllerFactory: NSObject {
    private override init() {}
    
    @objc static func makeSwiftUITappingViewController() -> UIViewController {
        SwiftUIViewController(content: SwiftUITappingView())
    }
    
    @objc static func makeSwiftUITypingViewController() -> UIViewController {
        SwiftUIViewController(content: SwiftUITypingView())
    }
}
