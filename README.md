# VipulTask

An iOS application that displays stock holdings and a portfolio summary with expand/collapse behavior. Built using UIKit (programmatic UI only) and MVVM architecture, following Apple’s best practices


✨ Features
- Stock holdings list
- Portfolio summary (expand / collapse)
- Current Value, Total Investment, P&L, Today’s P&L
- Profit/Loss percentage calculation
- Offline support via cached API response
- Clean UI built entirely in code
- Unit tests for business logic and ViewModel


🧱 Architecture

MVVM + Clean separation

- DTOs isolate API models from domain models
- Use Cases handle business calculations
- ViewModels expose state via callbacks


🎨 UI

- UIKit only (no Storyboards, no SwiftUI)
- Auto Layout via constraints
- Expand / collapse animation
- Adaptive for all iOS devices

🛠 Requirements

- Xcode 15+
- iOS 15+
- Swift 5.x
- UIKit
