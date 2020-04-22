class AzureB2CConfig {
  static final String clientId = '71643b25-e3d8-400a-9912-d3a482db0e98';
  static final String redirectUrl =
      'com.onmicrosoft.upaiqtodolistClient-v2://oauth/redirect';
  static final String discoveryUrl =
      'https://ServerXPocFlutterApp.b2clogin.com/tfp/ServerXPocFlutterApp.onmicrosoft.com/B2C_1_flutter_userflow/v2.0/.well-known/openid-configuration';
  static final List<String> scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
  ];
}
