class TwitterAuthToken {
  final String accessToken;
  final String tokenType;
  final String? refreshToken;
  final int expiresIn;
  final String scope;

  TwitterAuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.expiresIn,
    required this.scope,
  });

  factory TwitterAuthToken.fromJson(Map<String, dynamic> json) {
    return TwitterAuthToken(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      scope: json['scope'],
    );
  }
} 