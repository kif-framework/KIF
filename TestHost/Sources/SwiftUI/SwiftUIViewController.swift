//
//  SwiftUIViewController.swift
//  KIF
//
//  Created by Bartłomiej Włodarczak on 03/02/2025.
//

import UIKit
import SwiftUI

final class SwiftUIViewController<Content: View>: UIViewController {
    private let hostingController: UIHostingController<Content>
    
    init(content: Content) {
        hostingController = UIHostingController(rootView: content)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}
