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
- 🎨 **Advanced Theme Customization** - Custom brand colors for light and dark themes
- 🖼️ **Custom Logo Support** - Replace header logo with your brand logo
- 🌍 **Dynamic Language Switching** - Runtime language change (English and Arabic with RTL)
- 📬 Message receiving callback for custom notification handling
- ⚠️ **Comprehensive Error Handling** - Global and view-specific error callbacks
- ⚡ Quick access to active chats
- 🏗️ Environment-based configuration (Production/Development)
- 🔒 Secure, predefined API endpoints
- 🎨 SwiftUI native components with automatic color generation

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
        // Create environment configuration
        let config = EnvironmentConfig.production(enableLogging: false) // or .development()
        
        // Initialize BabylAI with environment configuration and custom theming
        BabylAISDK.shared.initialize(
            with: config,
            locale: .english, // or .arabic
            userInfo: [
                "name": "John Doe",
                "email": "johndoe@example.com",
                "phone": "+1234567890"
            ],
            themeConfig: ThemeConfig(
                primaryColorHex: "#4A6741",           // Elegant forest green for light theme
                secondaryColorHex: "#D4AF37",         // Sophisticated gold for light theme
                primaryColorDarkHex: "#81C784",       // Soft sage green for dark theme
                secondaryColorDarkHex: "#F9D71C",     // Warm amber for dark theme
                headerLogo: UIImage(named: "your_custom_logo") // Optional: Your brand logo
            ),
            onMessageReceived: { message in
                // Optional: Handle global incoming messages
                print("New message: \(message)")
            },
            onErrorReceived: { error in
                // Optional: Handle global errors
                print("❌ SDK Error [\(error.errorCode)]: \(error.userFriendlyMessage)")
            }
        )
        
        // IMPORTANT: You MUST set up a token callback for the package to work
        BabylAISDK.shared.setTokenCallback {
            // Example implementation to get a token
            return await getToken() // Return your access token as string
        }
        
        // Optional: Set up global error handling callback
        BabylAISDK.shared.setErrorCallback { error in
            print("❌ SDK Error [\(error.errorCode)]: \(error.userFriendlyMessage)")
            // Handle errors globally - show notifications, log to analytics, etc.
        }
        
        // Optional: Change language dynamically after initialization
        BabylAISDK.shared.setLocale(.arabic) // Switch to Arabic with RTL support
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

You can create environment configurations using factory methods:

```swift
// Production environment (logging disabled by default)
let productionConfig = EnvironmentConfig.production()

// Production environment with logging enabled
let productionConfigWithLogging = EnvironmentConfig.production(enableLogging: true)

// Development environment (logging enabled by default)
let developmentConfig = EnvironmentConfig.development()

// Development environment with custom timeouts
let customDevConfig = EnvironmentConfig.development(
    enableLogging: true,
    connectionTimeout: 60000,
    receiveTimeout: 30000
)
```

### Dynamic Language Switching

The BabylAI SDK supports dynamic language switching without requiring re-initialization. You can change the language at runtime and the SDK will update all text content and layout direction accordingly.

#### Setting Language Dynamically

```swift
// Switch to Arabic with RTL support
BabylAISDK.shared.setLocale(.arabic)

// Switch back to English with LTR support
BabylAISDK.shared.setLocale(.english)

// Get current locale
let currentLocale = BabylAISDK.shared.getLocale()
```

#### Example with UI Controls

```swift
struct LanguageSwitcher: View {
    @State private var isArabic = false
    
    var body: some View {
        HStack {
            Text("Arabic Language")
            Spacer()
            Toggle("", isOn: $isArabic)
                .onChange(of: isArabic) { enabled in
                    // Update SDK language dynamically
                    BabylAISDK.shared.setLocale(enabled ? .arabic : .english)
                }
        }
        .padding()
    }
}
```

#### Language Features

- **English (.english)**:
  - Left-to-right (LTR) layout direction
  - English text content and labels
  - Western number formatting

- **Arabic (.arabic)**:
  - Right-to-left (RTL) layout direction
  - Arabic text content and labels
  - Arabic/Eastern number formatting
  - Proper RTL text alignment

#### Notes

- Language changes take effect immediately in active SDK views
- The locale setting persists across SDK sessions
- RTL layout automatically adjusts all UI components, icons, and navigation
- No re-initialization required when switching languages

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

### 4. UIKit Implementation

For UIKit-based applications, you can use the SDK's UIKit helper methods:

#### Basic UIKit Usage

```swift
import UIKit
import BabylAI

class ViewController: UIViewController {
    
    @IBAction func openChatTapped(_ sender: UIButton) {
        // Present the chat interface
        BabylAISDK.shared.present(
            theme: .light,
            from: self,
            screenId: "YOUR_SCREEN_ID"
        )
    }
    
    @IBAction func openActiveChatTapped(_ sender: UIButton) {
        // Present active chat directly
        BabylAISDK.shared.presentActiveChat(
            theme: .light,
            from: self,
            screenId: "YOUR_SCREEN_ID"
        )
    }
}
```

#### Advanced UIKit Usage

```swift
class ChatViewController: UIViewController {
    
    func presentBabylAI() {
        // Get a view controller instance for custom presentation
        let chatController = BabylAISDK.shared.viewerController(
            theme: .light,
            isDirect: false,
            screenId: "YOUR_SCREEN_ID"
        )
        
        // Present with custom animation or navigation
        present(chatController, animated: true)
        
        // Or push to navigation stack
        // navigationController?.pushViewController(chatController, animated: true)
    }
    
    private func handleNewMessage(_ message: String) {
        // Handle incoming messages from BabylAI
        DispatchQueue.main.async {
            // Update UI, show notifications, etc.
            print("Received: \(message)")
        }
    }
}
```

## API Reference

### BabylAISDK Class

#### Methods

- `BabylAISDK.shared.initialize(with: EnvironmentConfig, locale: BabylAILocale, screenId: String, userInfo: [String: Any]? = nil, themeConfig: ThemeConfig? = nil)`: Initialize BabylAI with environment configuration and optional theme customization
- `BabylAISDK.shared.setTokenCallback(_ callback: @escaping () async throws -> String)`: Set a callback function that will be called when the token needs to be refreshed
- `BabylAISDK.shared.setErrorCallback(_ callback: @escaping (BabylAIError) -> Void)`: Set a global error callback to handle all SDK errors
- `BabylAISDK.shared.setLocale(_ locale: BabylAILocale)`: Change the SDK language dynamically without re-initialization
- `BabylAISDK.shared.getLocale() -> BabylAILocale`: Get the currently selected SDK language
- `BabylAISDK.shared.viewer(theme: BabylAITheme = .light, isDirect: Bool = false, onMessageReceived: ((String) -> Void)? = nil, onErrorReceived: ((BabylAIError) -> Void)? = nil, onDismiss: (() -> Void)? = nil) -> some View`: Get the BabylAI chat interface as a SwiftUI view
- `BabylAISDK.shared.makeView(theme: BabylAITheme, userInfo: [String: Any], onMessageReceived: ((String) -> Void)? = nil, onErrorReceived: ((BabylAIError) -> Void)? = nil) -> some View`: Create the main SDK view
- `BabylAISDK.shared.present(theme: BabylAITheme, from: UIViewController, screenId: String)`: Present the chat interface from a UIKit view controller
- `BabylAISDK.shared.presentActiveChat(theme: BabylAITheme, from: UIViewController, screenId: String)`: Present the active chat directly from a UIKit view controller
- `BabylAISDK.shared.viewerController(theme: BabylAITheme, isDirect: Bool, screenId: String) -> UIViewController`: Get a UIKit view controller instance for custom presentation

#### Environment Configuration

- `EnvironmentConfig.production(enableLogging: Bool = false, connectionTimeout: Int = 30000, receiveTimeout: Int = 15000)`: Create production environment configuration
- `EnvironmentConfig.development(enableLogging: Bool = true, connectionTimeout: Int = 30000, receiveTimeout: Int = 15000)`: Create development environment configuration

#### Theme Configuration

- `BabylAITheme.light`: Light theme
- `BabylAITheme.dark`: Dark theme
- `ThemeConfig(primaryColor, secondaryColor, primaryColorDark, secondaryColorDark, headerLogo)`: Comprehensive theme customization with separate light/dark colors and custom logo support
- `ThemeConfig(primaryColorHex, secondaryColorHex, primaryColorDarkHex, secondaryColorDarkHex, headerLogo)`: Convenience initializer using hex color strings

#### Locale Configuration

- `BabylAILocale.english`: English language with LTR layout
- `BabylAILocale.arabic`: Arabic language with RTL layout

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
| theme | BabylAITheme | UI theme (.light or .dark) |
| locale | BabylAILocale | Language (.english or .arabic) |
| themeConfig | ThemeConfig? | Optional theme customization with brand colors and logo |
| isDirect | Bool | Whether to open active chat directly |
| onMessageReceived | ((String) -> Void)? | Callback for handling new messages |
| onErrorReceived | ((BabylAIError) -> Void)? | Callback for handling view-specific errors |
| onDismiss | (() -> Void)? | Callback for dismissal/back navigation |

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

## Error Handling

The BabylAI SDK provides comprehensive error handling with categorized error codes, detailed descriptions, and recovery suggestions. All errors are mapped to standardized `BabylAIError` instances with unique error codes for easy documentation and debugging.

### Setting Up Error Handling

```swift
// Set global error callback during initialization
BabylAISDK.shared.setErrorCallback { error in
    print("Error Code: \(error.errorCode)")
    print("Description: \(error.errorDescription ?? "No description")")
    
    if let suggestion = error.recoverySuggestion {
        print("Recovery: \(suggestion)")
    }
    
    // Handle specific error types
    switch error {
    case .sdkNotInitialized:
        // Re-initialize the SDK
        break
    case .tokenExpired:
        // Refresh authentication
        break
    case .networkError:
        // Show network error UI
        break
    default:
        // Handle other errors
        break
    }
}
```

### Error Handling in Views

In addition to the global error callback, individual views can also handle errors locally:

```swift
BabylAISDK.shared.viewer(
    theme: .light,
    onMessageReceived: { message in
        // Handle new messages
        handleNewMessage(message)
    },
    onErrorReceived: { error in
        // Handle errors specific to this view instance
        handleViewError(error)
    }
)
```

### Error Categories

#### Network Errors (1000-1999)
- **BABYLAI_NET_1001**: Connection timeout
- **BABYLAI_NET_1002**: Server unavailable
- **BABYLAI_NET_1003**: Invalid response
- **BABYLAI_NET_[statusCode]**: Request failed with specific HTTP status code

#### Authentication Errors (2000-2999)
- **BABYLAI_AUTH_2001**: Authentication failed
- **BABYLAI_AUTH_2002**: Token expired
- **BABYLAI_AUTH_2003**: Invalid token
- **BABYLAI_AUTH_2004**: Token refresh failed
- **BABYLAI_AUTH_2005**: Unauthorized access

#### Configuration Errors (3000-3999)
- **BABYLAI_CFG_3001**: SDK not initialized
- **BABYLAI_CFG_3002**: Invalid configuration
- **BABYLAI_CFG_3003**: Missing required parameter
- **BABYLAI_CFG_3004**: Invalid environment

#### Data Errors (4000-4999)
- **BABYLAI_DATA_4001**: Data parsing error
- **BABYLAI_DATA_4002**: Invalid data format
- **BABYLAI_DATA_4003**: Data not found
- **BABYLAI_DATA_4004**: Data corrupted

#### UI Errors (5000-5999)
- **BABYLAI_UI_5001**: View presentation failed
- **BABYLAI_UI_5002**: Theme configuration error
- **BABYLAI_UI_5003**: Localization error

### Error Properties

Each `BabylAIError` provides:
- `errorCode`: Unique error code for documentation
- `errorDescription`: Human-readable error description
- `recoverySuggestion`: Suggested action to resolve the error
- `userFriendlyMessage`: User-friendly error message
- `logEntry`: Dictionary for logging and analytics

### Best Practices

1. **Always set an error callback** to handle SDK errors gracefully
2. **Use error codes** for documentation and support
3. **Implement error code-based handling** for better user experience
4. **Log errors** with the provided `logEntry` for debugging
5. **Provide recovery suggestions** to users when possible
6. **Test error scenarios** to ensure proper error handling

> **Note**: View-specific error callbacks will be called in addition to the global error callback, giving you flexibility to handle errors at both global and local levels.

## Contributing

For any issues or feature requests, please contact the package maintainers or submit an issue on the repository.

## License

Copyright © 2025 BabylAI

This software is provided under a custom license agreement. Usage is permitted only with explicit authorization from BabylAI. This software may not be redistributed, modified, or used in derivative works without written permission from BabylAI.

All rights reserved.


