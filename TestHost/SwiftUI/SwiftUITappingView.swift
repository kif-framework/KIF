//
//  SwiftUITappingView.swift
//  TestHost
//
//  Created by Bartłomiej Włodarczak on 03/02/2025.
//

import SwiftUI

struct SwiftUITappingView: View {
    var body: some View {
        List {
            TextWithTapCount(text: "Text with tap gesture")
            TextWithTapCount(text: "Partially offscreen text with tap gesture")
                .offset(x: 100)
            ButtonWithTapCount()
            ToggleWithState()
            StepperWithValue()
            ImageWithLongPressGesture()
            UILabelWithTapCount()
        }
    }
}

#Preview {
    SwiftUITappingView()
}

private struct ButtonWithTapCount: View {
    @State var count = 0

    var body: some View {
        HStack {
            Text("Tap count: \(count)")
            Spacer()
            Button("Button") {
                count += 1
            }
        }
    }
}

private struct TextWithTapCount: View {
    let text: String
    @State var count = 0

    var body: some View {
        HStack {
            Text("Tap count: \(count)")
            Spacer()
            Text(text)
                .foregroundColor(.blue)
                .onTapGesture {
                    count += 1
                }
        }
    }
}

private struct ToggleWithState: View {
    @State var enabled: Bool = true
    
    var body: some View {
        HStack {
            Text(enabled ? "Enabled" : "Disabled")
            Spacer()
            Toggle("", isOn: $enabled)
                .withAccessibility(label: "Toggle switch")
        }
    }
}

private struct StepperWithValue: View {
    @State var value = 50
    
    var body: some View {
        HStack {
            Text("Value: \(value)")
            Spacer()
            Stepper(value: $value, label: {})
        }
    }
}

private struct ImageWithLongPressGesture: View {
    @State var filled = false

    var body: some View {
        HStack {
            let gestureText = filled ? "Long press" : "Tap"
            Text("\(gestureText) to toggle")
            
            Spacer()
        
            let imageName = filled ? "heart.fill" : "heart"
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.red)
                .onTapGesture {
                    if !filled { filled = true }
                }
                .onLongPressGesture {
                    if filled { filled = false }
                }
                
        }
    }
}

private struct UILabelWithTapCount: View {
    @State var count = 0
    
    var body: some View {
        HStack {
            Text("Tap count: \(count)")
            UILabelWrapper(onTapGesture: { self.count += 1 })
        }
    }
}

private struct UILabelWrapper: UIViewRepresentable {
    let onTapGesture: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let label = UILabel()
        label.text = "UIViewRepresentable label"
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator,
                                                          action: #selector(Coordinator.handleTapGesture)))
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.addArrangedSubview(label)
        return stackView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    class Coordinator: NSObject {
        let onTapGesture: () -> Void
        
        init(onTapGesture: @escaping () -> Void) {
            self.onTapGesture = onTapGesture
        }
        
        @objc func handleTapGesture() {
            onTapGesture()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTapGesture: onTapGesture)
    }
}
