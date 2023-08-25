import 'package:flutter/material.dart';

class ContactController extends TextEditingController {
  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController deviceCodeController = TextEditingController();
  static TextEditingController activeCodeController = TextEditingController();
  static TextEditingController defaultActiveCodeController =
      TextEditingController();
}
