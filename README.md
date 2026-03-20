# TrueLayer iOS WebView SDK

A lightweight SDK that embeds TrueLayer's payment flow inside a native iOS WebView. It provides a drop-in transparent overlay that presents the payment UI and communicates results back to the host app through a native bridge. From the merchant's perspective, the integration is a single view modifier (SwiftUI) or view controller (UIKit) call — the SDK handles the WebView lifecycle, JavaScript communication, bank redirects, and cancellation internally.

The SDK is distributed as an XCFramework via this repository. Minimum supported version is iOS 14.0.

## Requirements

- iOS 14.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add the package to your `Package.swift` or via Xcode:

```
https://github.com/TrueLayer/truelayer-ios-webview-sdk
```

Then import the module:

```swift
import TrueLayerWebViewSDK
```

## Usage

Create a `Configuration` with the payment credentials obtained from the [TrueLayer Payments API](https://docs.truelayer.com/docs/payments-api):

```swift
let configuration = Configuration(
    paymentId: "<payment-id>",
    resourceToken: "<resource-token>",
    production: true // false for sandbox
)
```

### SwiftUI

Use the `.trueLayerPayment` view modifier to present the payment flow:

```swift
struct PaymentView: View {
    @State private var showPayment = false
    let configuration: Configuration

    var body: some View {
        Button("Pay") {
            showPayment = true
        }
        .trueLayerPayment(
            isPresented: $showPayment,
            configuration: configuration,
            onResult: { result in
                switch result {
                case .success:
                    // Payment flow completed successfully
                    break
                case .failure(let failure):
                    handleFailure(failure)
                }
                showPayment = false
            }
        )
    }
}
```

### UIKit

Present `TLWebViewController` modally:

```swift
let viewController = TLWebViewController(configuration: configuration)
viewController.modalPresentationStyle = .overFullScreen

viewController.onResult = { [weak self] result in
    self?.dismiss(animated: true)

    switch result {
    case .success:
        // Payment flow completed successfully
        break
    case .failure(let failure):
        self?.handleFailure(failure)
    }
}

present(viewController, animated: true)
```

### Configuration options

| Parameter | Type | Description |
|-----------|------|-------------|
| `paymentId` | `String` | Payment identifier from the TrueLayer API |
| `resourceToken` | `String` | Resource token for authentication |
| `production` | `Bool` | `true` for production, `false` for sandbox (default) |
| `maxWaitForResult` | `Int?` | Max seconds to wait for a payment result |
| `uiSettings` | `UISettings?` | UI customization (merchant logo, language) |
| `hostedResultScreen` | `HostedResultScreen?` | Hosted result screen with return URI |

### Result handling

The `Result` enum has two cases:

- **`.success`** — The user completed the payment flow. This does **not** guarantee settlement; always confirm the final payment status via [webhooks](https://docs.truelayer.com/docs/webhooks) (e.g. `payment_settled`, `payment_creditable`).
- **`.failure`** — The flow failed or was cancelled. Failures are split into two categories:

| Category | Meaning | Reasons |
|----------|---------|---------|
| `.app(App)` | SDK or environment failure | `noInternet`, `expired`, `canceled`, `invalidParameters`, `sdkLoadFailed`, `unknownError`, `unknown` |
| `.api(Api)` | Payments API or provider failure | `canceled`, `unknown` |

Both `App` and `Api` expose a `reason` and a `debugMessage` for troubleshooting.

```swift
func handleFailure(_ failure: Result.Failure) {
    switch failure {
    case .app(let app):
        switch app.reason {
        case .canceled:
            // User dismissed the flow intentionally
            break
        case .noInternet:
            // No network — prompt the user to retry
            break
        default:
            print("App failure: \(app.reason) — \(app.debugMessage)")
        }
    case .api(let api):
        print("API failure: \(api.reason) — \(api.debugMessage)")
    }
}
```

## Documentation

- [TrueLayer Payments API](https://docs.truelayer.com/docs/payments-api)
- [TrueLayer Web SDK](https://docs.truelayer.com/docs/web-sdk)

## License

See [LICENSE](LICENSE) for details.
