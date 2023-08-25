import 'package:flutter/material.dart';
import 'package:phonebookonline/controller/contactcontroller.dart';
import 'package:phonebookonline/screens/addeditscreen.dart';
import 'package:phonebookonline/utils/network.dart';
import 'package:phonebookonline/utils/extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static bool isEditing = false;
  static int idx = 0;
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Network.checkInternet(context);
    Future.delayed(const Duration(seconds: 3)).then((valye) async {
      Network.isConnect
          ? Network.getContact().then((value) async {
              await Future.delayed(const Duration(seconds: 3));
              setState(() {});
            })
          : Network.showInternetError(context); //
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Network.checkInternet(context);
                Future.delayed(const Duration(seconds: 3)).then((value) {
                  if (Network.isConnect) {
                    ContactController.nameController.text = '';
                    ContactController.phoneController.text = '';
                    HomeScreen.isEditing = false;
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CUScreen()))
                        .then((value) {
                      Network.getContact().then((value) async {
                        await Future.delayed(const Duration(seconds: 5));
                        setState(() {});
                      });
                    });
                  } else {
                    Network.showInternetError(context);
                  }
                });
              },
              elevation: 0,
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
              title: Text('دفترچه تلفن آنلاین',
                  style: TextStyle(
                      fontSize: ScreenSize(context).screenWidth <= 1000
                          ? 14
                          : ScreenSize(context).screenWidth * 0.012)),
              leading: const Icon(Icons.import_contacts_sharp),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      Network.checkInternet(context);
                      Future.delayed(const Duration(seconds: 3)).then((value) {
                        if (Network.isConnect) {
                          Network.getContact().then((value) async {
                            await Future.delayed(const Duration(seconds: 3));
                            setState(() {});
                          });
                        } else {
                          Network.showInternetError(context);
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                    )),
              ],
            ),
            body: ListView.builder(
                itemCount: Network.contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              fontSize: ScreenSize(context).screenWidth <= 1000
                                  ? 14
                                  : ScreenSize(context).screenWidth * 0.012),
                        )),
                    trailing: IconButton(
                      onPressed: () {
                        Network.checkInternet(context);
                        Future.delayed(const Duration(seconds: 3))
                            .then((value) {
                          if (Network.isConnect) {
                            HomeScreen.idx = index;
                            HomeScreen.isEditing = true;
                            ContactController.nameController.text =
                                Network.contacts[index].fullName;
                            ContactController.phoneController.text =
                                Network.contacts[index].phone;
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CUScreen()))
                                .then((value) {
                              Network.getContact().then((value) async {
                                await Future.delayed(
                                    const Duration(seconds: 5));
                                setState(() {});
                              });
                            });
                          } else {
                            Network.showInternetError(context);
                          }
                        });
                      },
                      icon: Icon(Icons.edit,
                          size: ScreenSize(context).screenWidth <= 1000
                              ? 14
                              : ScreenSize(context).screenWidth * 0.012),
                    ),
                    title: Text(Network.contacts[index].fullName,
                        style: TextStyle(
                            fontSize: ScreenSize(context).screenWidth <= 1000
                                ? 14
                                : ScreenSize(context).screenWidth * 0.012)),
                    subtitle: Text(Network.contacts[index].phone,
                        style: TextStyle(
                            fontSize: ScreenSize(context).screenWidth <= 1000
                                ? 14
                                : ScreenSize(context).screenWidth * 0.012)),
                    onLongPress: () {
                      Network.checkInternet(context);
                      Future.delayed(const Duration(seconds: 3)).then((value) {
                        if (Network.isConnect) {
                          Network.deleteContact(
                              id: Network.contacts[index].id.toString());
                          Network.getContact().then((value) async {
                            await Future.delayed(const Duration(seconds: 5));
                            setState(() {});
                          });
                        } else {
                          Network.showInternetError(context);
                        }
                      });
                    },
                  );
                })));
  }
}
