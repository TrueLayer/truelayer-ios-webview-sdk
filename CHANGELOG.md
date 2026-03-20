# Changelog

## 0.0.1

Initial release of the TrueLayer iOS WebView SDK.

### Features

- **SwiftUI support** — present the payment flow via the `.trueLayerPayment` view modifier
- **UIKit support** — present the payment flow via `TLWebViewController`
- **`Configuration`** — configure the payment session with:
  - `paymentId` and `resourceToken` from the TrueLayer Payments API
  - `production` flag to switch between sandbox and production environments
  - `maxWaitForResult` to control the timeout before showing a result screen
  - `uiSettings` for UI customization (merchant logo URI, language)
  - `hostedResultScreen` for redirect-based result handling with a `returnUri`
- **`Result`** — structured result type with:
  - `.success` — the user completed the payment flow
  - `.failure` — the flow ended with a cancellation or error, with detailed `App` and `Api` failure reasons
