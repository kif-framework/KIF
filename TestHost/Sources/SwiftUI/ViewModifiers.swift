//
//  ViewModifiers.swift
//  KIF
//
//  Created by Bartłomiej Włodarczak on 03/02/2025.
//

import SwiftUI

extension View {
    func withAccessibility(label: String) -> some View {
        self.modifier(AccessibilityLabelModifier(label))
    }
}

private struct AccessibilityLabelModifier: ViewModifier {
    let label: String
    
    init(_ label: String) {
        self.label = label
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .accessibilityLabel(label)
        } else {
            content
                .accessibility(label: Text(label))
        }
    }
}


