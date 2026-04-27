//
//  ErrorView.swift
//  Places-Test-App
//
//  Created by Zeynep Turnalı on 26.04.2026.
//

import SwiftUI

// MARK: - Error View
struct ErrorView: View {
    
    // MARK: - Properties
    let message: String
    let onDismiss: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: Constants.UI.mediumSpacing) {
            // Icon
            ZStack {
                Circle()
                    .fill(.white.opacity(Constants.UI.whiteBackgroundOpacity))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.white)
                    .font(.title3)
            }
            .accessibilityHidden(true)
            
            // Message
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Dismiss Button
            Button {
                Logger.ui("Dismissing error message", level: .info)
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.white.opacity(0.7))
                    .font(.callout)
                    .fontWeight(.medium)
                    .padding(Constants.UI.dismissButtonPadding)
                    .background(.white.opacity(Constants.UI.whiteBackgroundOpacity))
                    .clipShape(Circle())
            }
            .accessibilityLabel(Constants.Accessibility.Messages.dismissErrorLabel)
            .accessibilityHint(Constants.Accessibility.Messages.dismissErrorHint)
        }
        .padding(Constants.UI.largeSpacing)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.largeCornerRadius)
                .fill(.red.gradient)
                .shadow(color: .black.opacity(Constants.UI.iconBackgroundOpacity), radius: Constants.UI.largeShadowRadius, y: 5)
        )
        .padding(.horizontal)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Constants.Accessibility.Messages.errorLabel)
        .accessibilityValue(message)
        .accessibilityAddTraits(.isModal)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        ErrorView(
            message: "Failed to load locations. Please try again.",
            onDismiss: {}
        )
        
        ErrorView(
            message: "No internet connection. Please check your network settings.",
            onDismiss: {}
        )
    }
}
