# BabylAI SDK Error Handling Documentation

## Overview

The BabylAI SDK provides a comprehensive error handling system with categorized error codes, detailed descriptions, and recovery suggestions. All errors are mapped to standardized `BabylAIError` instances with unique error codes for easy documentation and debugging.

## Error Codes

### Network Errors (1000-1999)
- **BABYLAI_NET_1001**: Connection timeout
- **BABYLAI_NET_1002**: Server unavailable
- **BABYLAI_NET_1003**: Invalid response
- **BABYLAI_NET_[statusCode]**: Request failed with specific HTTP status code

### Authentication Errors (2000-2999)
- **BABYLAI_AUTH_2001**: Authentication failed
- **BABYLAI_AUTH_2002**: Token expired
- **BABYLAI_AUTH_2003**: Invalid token
- **BABYLAI_AUTH_2004**: Token refresh failed
- **BABYLAI_AUTH_2005**: Unauthorized access

### Configuration Errors (3000-3999)
- **BABYLAI_CFG_3001**: SDK not initialized
- **BABYLAI_CFG_3002**: Invalid configuration
- **BABYLAI_CFG_3003**: Missing required parameter
- **BABYLAI_CFG_3004**: Invalid environment

### Data Errors (4000-4999)
- **BABYLAI_DATA_4001**: Data parsing error
- **BABYLAI_DATA_4002**: Invalid data format
- **BABYLAI_DATA_4003**: Data not found
- **BABYLAI_DATA_4004**: Data corrupted

### UI Errors (5000-5999)
- **BABYLAI_UI_5001**: View presentation failed
- **BABYLAI_UI_5002**: Theme configuration error
- **BABYLAI_UI_5003**: Localization error

### System Errors (6000-6999)
- **BABYLAI_SYS_6001**: System error
- **BABYLAI_SYS_6002**: Memory error
- **BABYLAI_SYS_6003**: File system error

### Unknown Errors (9000-9999)
- **BABYLAI_UNK_9001**: Unknown error

## Usage Examples

### Setting Up Error Handling

```swift
// Set global error callback
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

### Error Callback in Methods

```swift
// Using error callback in presentation methods
BabylAISDK.shared.present(
    theme: .light,
    from: self,
    isDirect: false,
    onMessageReceived: nil,
    onErrorReceived: { error in
        self.handleSDKError(error)
    }
)
```

### Internal Error Handling (SDK Development)

```swift
// Trigger errors from within the SDK
self.triggerBabylAIError(.sdkNotInitialized)
self.triggerError(someGenericError) // Will be mapped to BabylAIError
```

### Error Mapping

```swift
// Map any error to BabylAIError
let mappedError = ErrorMapper.map(originalError)

// Or use the convenience extension
let babylAIError = originalError.asBabylAIError
```

## Error Properties

Each `BabylAIError` provides:
- `errorCode`: Unique error code for documentation
- `errorDescription`: Human-readable error description
- `recoverySuggestion`: Suggested action to resolve the error
- `userFriendlyMessage`: User-friendly error message
- `logEntry`: Dictionary for logging and analytics

## Best Practices

1. **Always set an error callback** to handle SDK errors gracefully
2. **Use error codes** for documentation and support
3. **Implement error code-based handling** for better user experience
4. **Log errors** with the provided `logEntry` for debugging
5. **Provide recovery suggestions** to users when possible
6. **Test error scenarios** to ensure proper error handling

## Integration with Analytics

The error system provides structured data for analytics:

```swift
let errorLog = error.logEntry
// Send to analytics service
analytics.track("sdk_error", properties: errorLog)
```
