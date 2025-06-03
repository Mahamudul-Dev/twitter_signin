# twitter_signin

A Flutter package providing a clean, customizable, and easy-to-use OAuth 2.0  
authentication flow for Twitter. Supports seamless sign-in integration in your  
Flutter apps without relying on third-party SDKs.

---

## Features

- Twitter OAuth 2.0 authentication (Authorization Code Flow with PKCE)  
- No dependency on official Twitter SDKs  
- Easily customizable authentication flow (webview, browser, etc.)  
- Supports token exchange and refresh  
- Fully testable with dependency injection  
- Lightweight and simple API  

---

## Getting Started

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  twitter_signin: ^0.0.1
````

Then run:

```bash
flutter pub get
```

---

### Usage

Import the package and create an instance:

```dart
import 'package:twitter_signin/twitter_signin.dart';

final twitterOAuth2 = TwitterOAuth2(
  config: TwitterOAuth2Config(
    clientId: 'YOUR_TWITTER_CLIENT_ID',
    redirectUri: 'yourapp://callback',
  ),
  authenticateUser: ({required Uri url, required String scheme}) async {
    // Implement your method to launch URL and listen for redirect to your scheme.
    // For example, use url_launcher and uni_links packages.
    return await launchAndListenForRedirect(url, scheme);
  },
);

final token = await twitterOAuth2.authenticate();

print('Access token: ${token.accessToken}');
```

Replace `'YOUR_TWITTER_CLIENT_ID'` and `'yourapp://callback'` with your actual Twitter app credentials and registered redirect URI.

---

### OAuth2 Flow Details

This package implements the OAuth 2.0 Authorization Code Flow with PKCE:

1. Generate a code verifier and code challenge.
2. Open the Twitter authorization URL for user login.
3. Capture the authorization code from redirect URI.
4. Exchange authorization code for access and refresh tokens.
5. Use access tokens to authenticate API requests.

---

## API Reference

### Classes

* **TwitterOAuth2Config**
  Configuration holder for client ID, redirect URI, and scopes.

* **TwitterOAuth2**
  Main class to manage authentication flow.

* **TwitterToken**
  Model class representing access and refresh tokens.


## Contributing

Contributions are welcome! Please:

* Fork the repo
* Create a feature branch
* Open a pull request
* Report issues on GitHub

Check the [issues page](https://github.com/Mahamudul-Dev/twitter_signin/issues) for known bugs or feature requests.

---

## License

MIT License © 2025 Mahamudul Hasan
[GitHub Profile](https://github.com/Mahamudul-Dev)

---

## Support

If you find this package helpful, please give it a ⭐️ on GitHub!

---

## Contact

Created by Mahamudul Hasan
GitHub: [https://github.com/Mahamudul-Dev](https://github.com/Mahamudul-Dev)
