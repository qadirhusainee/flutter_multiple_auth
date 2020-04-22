import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/aad_oauth.dart';

class AzureAdConfig {
  static final String _clientId = '3866d288-8ef1-4e9f-9e70-6127f1375d97';
  static final String _tenantId = 'common';
  static final String _redirectUrl =
      'https://login.live.com/oauth20_desktop.srf';
  static final Config config = new Config(
    _tenantId,
    _clientId,
    "openid email profile api://2b1fde38-0d3f-4063-8f09-ce15b8646442/access_as_user",
    _redirectUrl,
  );
  static final AadOAuth oauth = AadOAuth(config);
}
