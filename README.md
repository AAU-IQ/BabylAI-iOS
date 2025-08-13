<p align="center">
  <img src="https://babylai.net/assets/logo-BdByHTQ3.svg" alt="BabylAI Logo" height="200"/>
</p>

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# BabylAI iOS SDK

An iOS SDK that provides integration with BabylAI chat functionality, supporting multiple themes and languages.

## Features

- 🚀 Easy integration with BabylAI chat
- 🌓 Support for light and dark themes
- 🌍 Multilingual support (English and Arabic)
- 📬 Message receiving callback for custom notification handling
- ⚡ Quick access to active chats
- 🏗️ Environment-based configuration (Production/Development)
- 🔒 Secure, predefined API endpoints

## Installation

Since this is a private package, you'll need to add it via Swift Package Manager:

In Xcode:
1. File → Add Packages...
2. Enter the repository URL: `https://github.com/AAU-IQ/BabylAI-iOS.git`
3. Select branch/version (e.g., `main` or specific version tag)
4. Add the `BabylAI` product to your app target

If the repository requires authentication, you'll need to configure your Git credentials or use an access token.

## Usage

### 1. Initialize BabylAI with Environment Configuration

First, initialize BabylAI with the appropriate environment configuration and set up the token callback:

```swift
import BabylAI

@main
struct MyApp: App {
    init() {
        // Initialize BabylAI with environment configuration
        BabylAISDK.shared.initialize(
            with: EnvironmentConfig.development(), // or .production()
            locale: .english, // or .arabic
            screenId: "YOUR_SCREEN_ID",
            userInfo: [:]
        )
        
        // IMPORTANT: You MUST set up a token callback for the package to work
        BabylAISDK.shared.setTokenCallback {
            // Example implementation to get a token
            return await getToken() // Return your access token as string
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

> ⚠️ **Important**: You must call `BabylAISDK.shared.initialize()` and `BabylAISDK.shared.setTokenCallback()` before using any other BabylAI functionality. Failure to do so will result in authentication errors when trying to launch the chat interface.

### Environment Configuration

The package supports two environments:

- **Production**: Uses production API endpoints, logging disabled by default
- **Development**: Uses development API endpoints, logging enabled by default

You can customize additional settings:

```swift
// Production environment with custom settings
BabylAISDK.shared.initialize(
    with: EnvironmentConfig.production(enableLogging: false),
    locale: .english,
    screenId: "YOUR_SCREEN_ID",
    userInfo: [:]
)

// Development environment with custom settings
BabylAISDK.shared.initialize(
    with: EnvironmentConfig.development(enableLogging: true),
    locale: .english,
    screenId: "YOUR_SCREEN_ID",
    userInfo: [:]
)
```

### 2. Basic Implementation

Here's a simple example of how to integrate BabylAI in your iOS app:

```swift
import BabylAI
import SwiftUI

struct ContentView: View {
    @State private var showChat = false
    
    var body: some View {
        VStack {
            Button("Open BabylAI Chat") {
                showChat = true
            }
        }
        .fullScreenCover(isPresented: $showChat) {
            BabylAISDK.shared.viewer(
                onMessageReceived: { message in
                    // Handle new message notifications
                    print("New message: \(message)")
                }
            )
        }
    }
}
```

### 3. Advanced Implementation

For a more complete implementation with theme and language switching:

```swift
struct BabylAIExample: View {
    @State private var showChat = false
    @State private var showActiveChat = false
    
    var body: some View {
        VStack {
            Button("Launch BabylAI") {
                showChat = true
            }
            
            Button("Launch Active Chat") {
                showActiveChat = true
            }
        }
        .fullScreenCover(isPresented: $showChat) {
            BabylAISDK.shared.viewer(
                onMessageReceived: { message in
                    // Implement your own notification handling here
                    // You can use any notification package or custom implementation
                }
            )
        }
        .fullScreenCover(isPresented: $showActiveChat) {
            BabylAISDK.shared.viewer(
                isDirect: true,
                onMessageReceived: { message in
                    // Handle messages for active chat
                }
            )
        }
    }
}
```

## API Reference

### BabylAISDK Class

#### Methods

- `BabylAISDK.shared.initialize(with: EnvironmentConfig, locale: BabylAILocale, screenId: String, userInfo: [String: Any])`: Initialize BabylAI with environment configuration
- `BabylAISDK.shared.setTokenCallback(_ callback: @escaping () async throws -> String)`: Set a callback function that will be called when the token needs to be refreshed
- `BabylAISDK.shared.viewer(isDirect: Bool = false, onMessageReceived: ((String) -> Void)? = nil) -> some View`: Get the BabylAI chat interface as a SwiftUI view
- `BabylAISDK.shared.present(from: UIViewController, isDirect: Bool = false, onMessageReceived: ((String) -> Void)? = nil)`: Present the chat interface from a UIKit view controller

#### Environment Configuration

- `EnvironmentConfig.production(enableLogging: Bool = false)`: Create production environment configuration
- `EnvironmentConfig.development(enableLogging: Bool = true)`: Create development environment configuration

### Token Callback

The token callback is essential for authentication with the BabylAI service. The callback should:

1. Make an API request to get a fresh token
2. Parse the response correctly (the token is at the root level with key "token")
3. Return the token as a string
4. Handle errors appropriately

Example response structure:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 900
}
```

### Automatic Token Refresh

The package automatically handles token expiration by:

1. Detecting 401 (Unauthorized) or 403 (Forbidden) HTTP errors
2. Automatically calling your token callback to get a fresh token
3. Storing the new token for subsequent requests

This ensures that your users won't experience disruptions when their token expires during a session.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| locale | BabylAILocale | Language (.english or .arabic) |
| isDirect | Bool | Whether to open active chat directly |
| onMessageReceived | ((String) -> Void)? | Callback for handling new messages |

## Message Handling

The package provides a callback for handling new messages through the `onMessageReceived` parameter. You can implement your own notification system or message handling logic. Here's an example of how you might handle new messages:

```swift
BabylAISDK.shared.viewer(
    onMessageReceived: { message in
        // Implement your preferred notification system
        // For example, using UserNotifications framework
        // or any other notification approach
        showCustomNotification(message)
    }
)
```

## Contributing

For any issues or feature requests, please contact the package maintainers or submit an issue on the repository.

## License

Copyright © 2024 BabylAI

This software is provided under a custom license agreement. Usage is permitted only with explicit authorization from BabylAI. This software may not be redistributed, modified, or used in derivative works without written permission from BabylAI.

All rights reserved.


