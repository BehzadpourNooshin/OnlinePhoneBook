import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phonebookonline/controller/contactcontroller.dart';
import 'package:phonebookonline/screens/homescreen.dart';
import 'package:phonebookonline/utils/extension.dart';
import 'package:phonebookonline/widgets/myBTNWidget.dart';
import 'package:phonebookonline/widgets/myTextFieldWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  Future<String?> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final String result;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      result = iosDeviceInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      result = androidDeviceInfo.id;
    } else if (Platform.isWindows) {
      var windowsDeviceInfo = await deviceInfoPlugin.windowsInfo;
      result = windowsDeviceInfo.deviceId;
    } else if (Platform.isMacOS) {
      var macInfo = await deviceInfoPlugin.macOsInfo;
      result = macInfo.systemGUID!;
    } else if (Platform.isLinux) {
      var linuxInfo = await deviceInfoPlugin.linuxInfo;
      result = linuxInfo.id;
    } else {
      var webInfo = await deviceInfoPlugin.webBrowserInfo;
      result = webInfo.userAgent!;
    }
    print(result);
    return result;
  }

  void showSuccessDialog(BuildContext context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        width: 100,
        text: "کد با موفقیت کپی شد !",
        title: "موفق",
        confirmBtnText: 'باشه',
        confirmBtnColor: Colors.redAccent,
        confirmBtnTextStyle:
            const TextStyle(fontSize: 16, color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    ContactController.activeCodeController.text = 'کد فعال‌سازی';
    ContactController.deviceCodeController.text = 'کد دستگاه';
    getDeviceInfo().then((value) {
      ContactController.deviceCodeController.text = value ?? 'کد دستگاه';
    });
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
              title: Text('فعال‌سازی',
                  style: TextStyle(
                      fontSize: ScreenSize(context).screenWidth <= 1000
                          ? 14
                          : ScreenSize(context).screenWidth * 0.012)),
              centerTitle: true,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: ContactController.deviceCodeController.text));
                      var bytes1 = utf8
                          .encode(ContactController.deviceCodeController.text);
                      var defaultActiveCode = sha512256.convert(bytes1);

                      ContactController.activeCodeController.text =
                          defaultActiveCode.toString();
                      ContactController.defaultActiveCodeController.text =
                          defaultActiveCode.toString();
                      showSuccessDialog(context);
                    },
                    child: MyTXTField(
                      controller: ContactController.deviceCodeController,
                      myTitle: ContactController.deviceCodeController.text,
                      errorText: '',
                      isEnable: false,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTXTField(
                    controller: ContactController.activeCodeController,
                    myTitle: ContactController.activeCodeController.text,
                    errorText: 'کد فعال‌سازی وارد شده نامعتبر است!',
                    isEnable: true,
                  ),
                  const SizedBox(height: 10),
                  MyBTN(
                      title: 'فعال‌سازی',
                      onPressed: () async {
                        if (ContactController.activeCodeController.text ==
                            ContactController
                                .defaultActiveCodeController.text) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isActive', true);
                        } else {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              width: 100,
                              text: "کد فعال‌سازی منطبق بر دستگاه نیست!",
                              title: "خطا",
                              confirmBtnText: 'باشه',
                              confirmBtnColor: Colors.redAccent,
                              confirmBtnTextStyle: const TextStyle(
                                  fontSize: 16, color: Colors.white));
                        }
                      })
                ],
              ),
            )));
  }
}
