import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/contacts.dart';

class Network {
  static Uri url = Uri.parse('https://retoolapi.dev/J3yf0U/contacts');
  static List<Contact> contacts = [];
  static bool isConnect = false;
  static Uri urlWithId(String id) {
    Uri url = Uri.parse('https://retoolapi.dev/J3yf0U/contacts/$id');
    return url;
  }

  static Future<bool> checkInternet(BuildContext context) async {
    Connectivity().onConnectivityChanged.listen((status) {
      if ((status == ConnectivityResult.wifi ||
          status == ConnectivityResult.mobile)) {
        isConnect = true;
      } else {
        showInternetError(context);
        isConnect = false;
      }
      print(Network.isConnect);
    });

    return isConnect;
  }

  static void showInternetError(BuildContext context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        width: 100,
        text: "شما به اینترنت متصل نیستید. ",
        title: "خطا",
        confirmBtnText: 'باشه',
        confirmBtnColor: Colors.redAccent,
        confirmBtnTextStyle:
            const TextStyle(fontSize: 16, color: Colors.white));
  }

  static Future<bool> getContact() async {
    contacts.clear();
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        List jsonDecode = convert.jsonDecode(response.body);
        for (var json in jsonDecode) {
          contacts.add(Contact.fromJson(json));
        }
      }
    });
    return true;
  }

  static Future<bool> postContact({required Contact contact}) async {
    bool successPost = false;
    //Contact contact = Contact(phone: phone, fullName: fullName);
    http.post(url, body: contact.toJson()).then((response) {
      if (response.statusCode == 200) {
        successPost = true;
      }
    });
    return successPost;
  }

  static Future<bool> putContact(
      {required Contact contact, required String id}) async {
    bool successPut = false;
    //Contact contact = Contact(phone: phone, fullName: fullName);
    http.put(urlWithId(id), body: contact.toJson()).then((response) {
      if (response.statusCode == 200) {
        successPut = true;
      }
    });
    return successPut;
  }

  static Future<bool> deleteContact({required String id}) async {
    bool successDelete = false;
    //Contact contact = Contact(phone: phone, fullName: fullName);
    http.delete(urlWithId(id)).then((response) {
      getContact();
      if (response.statusCode == 201) {
        successDelete = true;
      }
    });
    return successDelete;
  }
}
