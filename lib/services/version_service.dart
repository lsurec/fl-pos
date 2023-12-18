import 'package:package_info/package_info.dart';

class VersionService {
  Future<String> getVersionLocal() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    return appVersion;
  }
}
