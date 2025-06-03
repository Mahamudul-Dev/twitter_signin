import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';

import '../entity/twitter_oauth_config.dart';
import '../entity/twitter_oauth_token.dart';

class TwitterOAuth2 {
  final TwitterOAuth2Config config;
  final _random = Random();

  TwitterOAuth2(this.config);

  /// Initiates the OAuth2 authentication process with Twitter, opening a web
  /// view for user login and authorization. Exchanges the authorization code
  /// for an access token upon successful login.
  ///
  /// Returns a [TwitterAuthToken] containing the access token and other token
  /// details on successful authentication.
  ///
  /// Throws an [Exception] if the authorization code is not found or the token
  /// exchange fails.

  Future<TwitterAuthToken> authenticate() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    final authUrl = Uri.https("twitter.com", "/i/oauth2/authorize", {
      "response_type": "code",
      "client_id": config.clientId,
      "redirect_uri": config.redirectUri,
      "scope": config.scopes.join(" "),
      "state": _generateRandomString(12),
      "code_challenge": codeChallenge,
      "code_challenge_method": "S256",
    });

    final result = await FlutterWebAuth.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: Uri.parse(config.redirectUri).scheme,
    );

    final code = Uri.parse(result).queryParameters['code'];

    if (code == null) throw Exception("Authorization code not found");

    return await _fetchToken(code, codeVerifier);
  }

  /// Exchanges the authorization code for an access token and other token
  /// details using the Twitter OAuth2 token endpoint.
  ///
  /// Returns a [TwitterAuthToken] containing the access token and other token
  /// details on successful token exchange.
  ///
  /// Throws an [Exception] if the token exchange fails.
  Future<TwitterAuthToken> _fetchToken(String code, String codeVerifier) async {
    final response = await http.post(
      Uri.https("api.twitter.com", "/2/oauth2/token"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": config.redirectUri,
        "client_id": config.clientId,
        "code_verifier": codeVerifier,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Token exchange failed: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return TwitterAuthToken.fromJson(data);
  }

  /// Generates a 32-byte cryptographically secure random string, encoded as a
  /// URL-safe base64 string, suitable for use as an OAuth2 code verifier.
  ///
  /// The resulting string is 43 characters long, consisting of only the
  /// characters A-Z, a-z, 0-9, and _ and - (no = padding is used).
  String _generateCodeVerifier() {
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  /// Computes the code challenge from a given code verifier according to the
  /// PKCE specification.
  ///
  /// This is done by computing the SHA-256 hash of the verifier, then
  /// encoding the hash as a URL-safe base64 string, and finally removing any
  /// trailing "=" padding characters.
  ///
  /// The resulting code challenge is 43 characters long, consisting of only
  /// the characters A-Z, a-z, 0-9, and _ and - (no = padding is used).
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  /// Generates a cryptographically secure random string consisting of
  /// [length] characters from the given set of characters.
  ///
  /// The characters used are A-Z, a-z, 0-9. The resulting string is suitable
  /// for use as a state parameter in OAuth2 authorization requests.
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (_) => chars[_random.nextInt(chars.length)]).join();
  }
}