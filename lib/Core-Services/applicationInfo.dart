import 'package:package_info/package_info.dart';

class ApplicationInfo{
  static String appName;
  static String packageName;
  static String version;
  static String buildNumber;

  static intialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = '${packageInfo.version} +${packageInfo.buildNumber}';
  }
}