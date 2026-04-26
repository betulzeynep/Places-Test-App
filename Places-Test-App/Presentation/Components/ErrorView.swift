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
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
                .font(.title3)
                .accessibilityHidden(true)  // Icon decorative
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white.opacity(0.7))
                    .font(.title3)
            }
            .accessibilityLabel("Dismiss error")
            .accessibilityHint("Removes this error message")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.red.gradient)
        )
        .padding(.horizontal)
        .shadow(radius: 4)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Error: \(message)")
        .accessibilityAddTraits(.isModal)  // Error is important
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
