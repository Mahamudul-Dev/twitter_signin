class TwitterOAuth2Config {
  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  TwitterOAuth2Config({
    required this.clientId,
    required this.redirectUri,
    this.scopes = const ["tweet.read", "users.read", "offline.access"],
  });
}
