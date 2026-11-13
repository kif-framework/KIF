//
//  SwiftUIPassThroughViewController.swift
//  TestHost
//

import SwiftUI
import UIKit

/// Shows SwiftUI buttons in bars that span the screen's width and let touches through wherever they draw nothing,
/// as floating bars and overlays do.
final class SwiftUIPassThroughViewController: UIViewController {
    private let tapCountLabel = UILabel()
    private var tapCount = 0 {
        didSet { tapCountLabel.text = "Tap count: \(tapCount)" }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tapCountLabel.text = "Tap count: 0"
        tapCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tapCountLabel)

        let leadingBar = makeBar(
            HStack {
                Button("Leading button") { [weak self] in self?.tapCount += 1 }
                Spacer()
            }
        )
        let centeredBar = makeBar(
            Button("Centered button") { [weak self] in self?.tapCount += 1 }
        )

        NSLayoutConstraint.activate([
            leadingBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leadingBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            centeredBar.topAnchor.constraint(equalTo: leadingBar.bottomAnchor),
            centeredBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            centeredBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tapCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapCountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func makeBar<Content: View>(_ content: Content) -> UIView {
        let hostingController = UIHostingController(rootView: content.padding())
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let bar = PassThroughView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        bar.addSubview(hostingController.view)
        view.addSubview(bar)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: bar.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bar.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
        return bar
    }
}

/// Lets touches through wherever its subviews draw nothing.
private final class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event), hitView !== self else { return nil }
        // A hosting view receives every touch in its bounds, so check whether SwiftUI drew anything under the point.
        if hitView.layer.hitTest(convert(point, to: hitView.superview)) === hitView.layer {
            return nil
        }
        return hitView
    }
}
