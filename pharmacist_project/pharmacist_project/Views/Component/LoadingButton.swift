//
//  LoadingButton.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 16/9/24.
//

import SwiftUI

enum ButtonState {
    case active
    case loading
    case disabled
}

enum ButtonStyle {
    case fill
    case outline
}

struct LoadingButton: View {
    var title: String
    var style: ButtonStyle
    var action: () -> Void
    @Binding var buttonState: ButtonState

    // New customization parameters
    var backgroundColor: Color
    var foregroundColor: Color
    
    init(title: String, state: Binding<ButtonState>, style: ButtonStyle, backgroundColor: Color = Color(hex: "2EB5FA"), foregroundColor: Color = .white, action: @escaping () -> Void) {
        self.title = title
        self._buttonState = state
        self.style = style
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.action = action
    }

    var body: some View {
        Button(action: {
            if buttonState == .active {
                action()
            }
        }) {
            ZStack {
                if buttonState == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style == .outline ? backgroundColor : foregroundColor))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonBackgroundColor())
                        .cornerRadius(20)
                        .overlay(buttonOverlay())  // Ensure outline is visible during loading
                        .shadow(radius: 4)
                } else {
                    Text(title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonBackgroundColor())
                        .foregroundColor(buttonForegroundColor())
                        .cornerRadius(20)
                        .overlay(buttonOverlay())
                        .shadow(radius: 4)
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(buttonState == .disabled)
        }
    }
    
    private func buttonBackgroundColor() -> Color {
        switch style {
        case .fill:
            return buttonState == .disabled ? Color.gray : backgroundColor
        case .outline:
            return .clear
        }
    }
    
    private func buttonForegroundColor() -> Color {
        switch style {
        case .fill:
            return foregroundColor
        case .outline:
            return buttonState == .disabled ? Color.gray : backgroundColor
        }
    }
    
    private func buttonOverlay() -> some View {
        switch style {
        case .fill:
            return AnyView(EmptyView())
        case .outline:
            return AnyView(RoundedRectangle(cornerRadius: 20).stroke(buttonForegroundColor(), lineWidth: 2))
        }
    }
}

#Preview {
    @State var previewButtonState: Binding<ButtonState> = .constant(.active)

    return VStack {
        LoadingButton(title: "Login", state: previewButtonState, style: .fill, backgroundColor: Color(hex: "2EB5FA"), foregroundColor: Color.white) {
            print("Button pressed!")
        }
        
        LoadingButton(title: "Sign up", state: previewButtonState, style: .outline, backgroundColor: Color.pink, foregroundColor: Color.pink) {
            print("Button pressed!")
        }
    }
    .padding()
}
