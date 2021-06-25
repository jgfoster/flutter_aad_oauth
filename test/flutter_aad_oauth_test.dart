import 'package:flutter_aad_oauth/flutter_aad_oauth.dart';
import 'package:flutter_aad_oauth/model/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () async {
    var tenantId = '076af07d-e531-467c-85ae-491b611bde53';
    var applicationId = 'd84a0d45-a330-40c1-b618-39b7a0397f0c';
    final Config config = new Config(tenantId, applicationId,
        "openid profile offline_access", "redirectUri");
    final FlutterAadOauth oauth = new FlutterAadOauth(config);
    print(await oauth.getAccessToken());
  });
}
