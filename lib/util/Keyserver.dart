import 'package:http/http.dart' as http;

class Keyserver {
  static Future<String> upload(String publicKey) async {
    try {
      String baseUrl = "https://keyserver.ubuntu.com";
      Map<String, dynamic> data = {'keytext': publicKey};
      http.Response response = await http.post("$baseUrl/pks/add", body: data);
      return Future.value(getUrl(response.body));
    } catch (e) {
      return Future.value(null);
    }
  }

  static String getUrl(String uploadResponse) {
    print(uploadResponse);
    String baseUrl = "https://keyserver.ubuntu.com";
    RegExp keyIdRegexp = RegExp("{\"inserted\":\[\"[a-z0-9]*\/([a-z0-9]{40})\"",
        multiLine: true);
    var keyIdResult = keyIdRegexp.allMatches(uploadResponse);
    if (keyIdResult.isEmpty) {
      return null;
    }
    String keyId = keyIdResult.first.group(1);
    return "$baseUrl/pks/lookup?op=get&search=0x$keyId";
  }
}
