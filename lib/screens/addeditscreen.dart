import 'package:flutter/material.dart';
import 'package:phonebookonline/screens/homescreen.dart';
import 'package:phonebookonline/utils/network.dart';
import 'package:phonebookonline/utils/extension.dart';
import '../controller/contactcontroller.dart';
import '../models/contacts.dart';
import '../widgets/myBTNWidget.dart';
import '../widgets/myTextFieldWidget.dart';

class CUScreen extends StatefulWidget {
  const CUScreen({super.key});

  @override
  State<CUScreen> createState() => CUScreenState();
}

class CUScreenState extends State<CUScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Form(
            key: formKey,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.redAccent,
                  title: Text(
                      (HomeScreen.isEditing) ? 'ویرایش مخاطب' : 'مخاطب جدید',
                      style: TextStyle(
                          fontSize: ScreenSize(context).screenWidth <= 1000
                              ? 14
                              : ScreenSize(context).screenWidth * 0.012)),
                  centerTitle: true,
                  elevation: 0,
                ),
                body: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyTXTField(
                            myTitle: (HomeScreen.isEditing)
                                ? ContactController.nameController.text
                                : 'نام',
                            controller: ContactController.nameController,
                            errorText: '.لطفا نام را وارد نمایید',
                          ),
                          const SizedBox(height: 10),
                          MyTXTField(
                            myTitle: (HomeScreen.isEditing)
                                ? ContactController.phoneController.text
                                : 'شماره',
                            type: TextInputType.number,
                            controller: ContactController.phoneController,
                            errorText: '.لطفا شماره را وارد نمایید',
                          ),
                          const SizedBox(height: 20),
                          MyBTN(
                              title: HomeScreen.isEditing
                                  ? 'ویرایش کردن'
                                  : 'اضافه کردن',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Network.checkInternet(context);
                                  Future.delayed(const Duration(seconds: 3))
                                      .then((value) {
                                    if (Network.isConnect) {
                                      Contact item = Contact(
                                        fullName: ContactController
                                            .nameController.text,
                                        phone: ContactController
                                            .phoneController.text,
                                      );

                                      (HomeScreen.isEditing)
                                          ? Network.putContact(
                                              contact: item,
                                              id: Network
                                                  .contacts[HomeScreen.idx].id
                                                  .toString())
                                          : Network.postContact(contact: item);
                                      Navigator.pop(context);
                                    } else {
                                      Network.showInternetError(context);
                                    }
                                  });
                                }
                              })
                        ])))));
  }
}
                                  // else {
                                  //   Network.showInternetError(context);
                                  // }
                                 
                              
                        
  
 
