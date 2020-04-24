class AzureB2CConfig {
  static final String clientId = '4abd9456-954b-4321-a612-abc57144348f';
  // '71643b25-e3d8-400a-9912-d3a482db0e98';
  static final String redirectUrl = 'com.onmicrosoft.serverXPoc.flutterPoc://oauth/redirect';
      // 'com.onmicrosoft.upaiqtodolistClient-v2://oauth/redirect';
  static final String discoveryUrl = 'https://ServerXPocFlutterApp.b2clogin.com/tfp/ServerXPocFlutterApp.onmicrosoft.com/B2C_1_flutter_userflow/v2.0/.well-known/openid-configuration';
      // https://ServerXPocFlutterApp.b2clogin.com/tfp/ServerXPocFlutterApp.onmicrosoft.com/B2C_1_flutter_userflow/v2.0/.well-known/openid-configuration';
  static final List<String> scopes = <String>[
    '4abd9456-954b-4321-a612-abc57144348f',
    'openid',
    'profile',
    'email',
    'offline_access',
  ];
}
 // https://ServerXPocFlutterApp.b2clogin.com/ServerXPocFlutterApp.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_flutter_userflow&client_id=4abd9456-954b-4321-a612-abc57144348f&nonce=defaultNonce&redirect_uri=com.onmicrosoft.serverXPoc.flutterPoc%3A%2F%2Foauth%2Fredirect&scope=openid&response_type=id_token&prompt=login