//
//  SwiftUITypingView.swift
//  TestHost
//
//  Created by Bartłomiej Włodarczak on 10/02/2025.
//

import SwiftUI

struct SwiftUITypingView: View {
    var body: some View {
        List {
            TextFieldWithMirror()
        }
    }
}

#Preview {
    SwiftUITypingView()
}

private struct TextFieldWithMirror: View {
    @State var text = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(text.isEmpty ? "Fill text field" : "Clear text field") {
                if text.isEmpty {
                    text = "This is some inserted text"
                } else {
                    text = ""
                }
            }
            .buttonStyle(.plain)
            .foregroundColor(.blue)
            
            TextField("This is SwiftUI TextField", text: $text)
                .withAccessibility(label: "SwiftUI TextField")
                .textFieldStyle(.roundedBorder)
            
            Text(text)
        }
    }
}
