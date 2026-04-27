# Places Test App

A SwiftUI iOS application that fetches locations from a remote JSON endpoint and integrates with the Wikipedia app using deep linking.

## 📋 Overview

This project demonstrates:
- Clean Architecture with MVVM pattern
- SwiftUI with modern Swift Concurrency (async/await)
- Protocol-oriented design for testability
- Deep linking integration with Wikipedia app
- Comprehensive error handling and accessibility support

## 🎯 Features

- Fetches locations from remote JSON endpoint
- Alphabetically sorted location list
- Wikipedia deep linking with two modes:
  - **By Name**: Opens Wikipedia article in Places tab
  - **By Coordinates**: Opens Places tab at specific location
- Custom location input (search by name or coordinates)
- Coordinate validation and filtering
- Pull-to-refresh functionality
- Loading states and error handling
- Full accessibility support

## 🏗 Architecture

Clean Architecture with three distinct layers:

**Presentation Layer**
- SwiftUI Views (LocationsListView, CustomLocationInputView)
- ViewModel (@MainActor for UI state management)

**Domain Layer**
- Use Cases (FetchLocationsUseCase, OpenWikipediaUseCase)
- Business logic and validation

**Data Layer**
- Repository pattern (LocationRepository)
- Network service (NetworkService)
- Protocol-oriented design for testability

## 🔧 Technical Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Concurrency**: async/await, @MainActor
- **Architecture**: Clean Architecture + MVVM
- **Networking**: URLSession with generic Decodable support
- **Logging**: OSLog (unified logging)
- **Testing**: XCTest with mocks

### Deep Linking

Wikipedia integration uses custom URL schemes:

```
// Coordinates only
wikipedia://places?lat=52.3676&lon=4.9041

// With article URL
wikipedia://places?WMFArticleURL=https://en.wikipedia.org/wiki/Amsterdam
```

## 🧪 Testing

Unit tests covering key components:

- **LocationsViewModelTests**: State management and user interactions
- **FetchLocationsUseCaseTests**: Business logic and sorting
- **LocationValidationTests**: Coordinate validation and parsing

Tests use mocks to isolate dependencies and verify behavior.

Run tests: `Cmd + U` in Xcode

## 🚀 Getting Started

### Requirements
- Xcode 15.0+
- iOS 17.0+
- Wikipedia app (for deep linking)

### Installation

1. Clone the repository
2. Open `Places-Test-App.xcodeproj` in Xcode
3. Build and run (⌘R)

### Wikipedia App Setup

Install the modified Wikipedia app:
- Clone: https://github.com/betulzeynep/wikipedia-ios
- Build and run on the same device/simulator

### Testing Deep Links

1. Run Places Test App
2. Tap a location or enter custom coordinates/name
3. App opens Wikipedia at the specified location

## 🎨 Key Highlights

- **Clean Architecture**: Testable, maintainable code structure
- **Swift Concurrency**: Modern async/await throughout
- **Protocol-Oriented**: All dependencies injected via protocols
- **Error Handling**: User-friendly error messages with AppError protocol
- **Accessibility**: VoiceOver support with semantic labels
- **Logging**: OSLog for debugging (DEBUG builds only)

## 👤 Author

Betül Zeynep Seyis

---
*Built with SwiftUI and modern Swift patterns for the Wikipedia Places assignment*

