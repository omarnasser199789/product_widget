import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// A utility class for managing device information and checking operating system versions.
class DeviceInfoManager {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Fetches and prints device information such as model, manufacturer, and OS version.
  Future<void> getDeviceInformation() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        print('Device Model: ${androidInfo.model}');
        print('Device Manufacturer: ${androidInfo.manufacturer}');
        print('Device Android Version: ${androidInfo.version.release}');
        print('Device ID: ${androidInfo.id}');
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        print('Device Model: ${iosInfo.model}');
        print('Device Name: ${iosInfo.name}');
        print('Device iOS Version: ${iosInfo.systemVersion}');
        print('Device ID: ${iosInfo.identifierForVendor}');

        // Check if iOS version is greater than 16
        double iosVersion = double.parse(iosInfo.systemVersion.split('.')[0]);
        if (iosVersion > 16) {
          print('iOS version is greater than 16.');
        } else {
          print('iOS version is not greater than 16.');
        }
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }

  /// Checks if the iOS version is greater than 16.
  ///
  /// Returns `true` if the iOS version is greater than 16, `false` otherwise.
  Future<bool> isIOSVersionGreaterThan16() async {
    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        double iosVersion = double.parse(iosInfo.systemVersion.split('.')[0]);
        return iosVersion > 16;
      }else if(Platform.isAndroid){
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        print('Device Android Version: ${androidInfo.version.release}');
      }
      return false; // Return false for non-iOS platforms
    } catch (e) {
      print('Error getting device info: $e');
      return false; // Return false in case of error
    }
  }

  /// Checks if the Android version is greater than 12.
  ///
  /// Returns `true` if the Android version is greater than 12, `false` otherwise.
  Future<bool> isAndroidVersionGreaterThan12() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        int androidVersion = int.parse(androidInfo.version.release.split('.')[0]);
        return androidVersion > 12;
      } else {
        print('Not an Android device.');
        return false; // Return false for non-Android platforms
      }
    } catch (e) {
      print('Error getting device info: $e');
      return false; // Return false in case of error
    }
  }

  /// Checks if the operating system version is supported (greater than specific versions).
  ///
  /// Returns `true` if the operating system version is supported, `false` otherwise.
  ///
  /// This function automatically detects the platform and checks the appropriate OS version.
  Future<bool> isOperatingSystemVersionSupported() async {
    try {
      if (Platform.isIOS) {
        return await isIOSVersionGreaterThan16();
      } else if (Platform.isAndroid) {
        return await isAndroidVersionGreaterThan12();
      }
      return false; // Return false for non-supported platforms
    } catch (e) {
      print('Error getting device info: $e');
      return false; // Return false in case of error
    }
  }

}
