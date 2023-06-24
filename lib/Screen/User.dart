import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/Provider/UserProvider.dart';
import 'package:comic/Screen/Auth/Login.dart';
import 'package:comic/Screen/Home.dart';
import 'package:comic/Widgets/SnackBarWidget.dart';
import 'package:comic/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class User extends StatefulWidget {
  User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userName = TextEditingController();

  Future<void> submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Map<String, dynamic> data = {
      'name': userName.text,
      'credentials': userPhone.text,
    };

    final response = await Provider.of<UserProvider>(context, listen: false)
        .profileUpdate(data);

    ///what is i don't know for suggestion only
    if (!context.mounted) return;
    if (response['status'] == true) {
      snackBarWidget(context, response['message']);
      Navigator.of(context).pop();
    } else {
      snackBarWidget(context, 'SOMETHING WAS WRONG!');
    }
  }

  @override
  Widget build(BuildContext context) {
    // getTokenAndUser();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Future<void> _logout() async {
      final Map<String, dynamic> response =
          await Provider.of<UserProvider>(context, listen: false).logOut();

      if (response['status']) {
        snackBarWidget(context, response['message']);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MyApp()));
      } else {
        snackBarWidget(context, response['message']);
      }
    }

    // Future<void> _changeImage() async {
    //   final picker = ImagePicker();
    //   final data = await picker.pickImage(source: ImageSource.gallery);

    //   if (!context.mounted) return;
    //   if (data != null) {
    //     final response = Provider.of<UserProvider>(context, listen: false)
    //         .changeImage(File(data.path));
    //   }
    // }

    Future<void> _showModalBox(BuildContext context) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile Edit'),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            content: Form(
              key: _formKey,
              child: Container(
                height: 250,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: userName,
                        scrollPadding: const EdgeInsets.all(10),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: 'User Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Required';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: userPhone,
                        scrollPadding: EdgeInsets.all(10),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Required Phone';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        overlayColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.surfaceVariant),
                        splashColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onTap: () => submit(context),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.bebasNeue(fontSize: 24, letterSpacing: 3),
        ),
        actions: [
          // Consumer<UserProvider>(
          //   builder: (context, value, child) {
          //     return value.token == ''
          //         ? Container()
          //         : IconButton(
          //             onPressed: () {
          //               Navigator.of(context).push(MaterialPageRoute(
          //                   builder: (context) => const Home()));
          //             },
          //             icon: const Icon(Icons.notifications_outlined),
          //           );
          //   },
          // )
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Consumer<UserProvider>(
                            builder: (context, value, child) {
                              return CachedNetworkImage(
                                imageUrl: value.userData != null
                                    ? value.userData!.photo
                                    : 'https://cdn3d.iconscout.com/3d/premium/thumb/person-6877458-5638294.png',
                                placeholder: (context, i) =>
                                    const CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ),
                      userProvider.token == ''
                          ? Container()
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                    ],
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return value.userData == null
                          ? InkWell(
                              borderRadius: BorderRadius.circular(8),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.surfaceVariant),
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Login(
                                      name: '',
                                      password: '',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 150,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  // color: ,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Login'.toUpperCase(),
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.userData!.name,
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 25, letterSpacing: 3),
                                ),
                                Text(
                                  value.userData!.credentials,
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 25, letterSpacing: 3),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant),
                                  splashColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  onTap: () => _showModalBox(context),
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      // color: ,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Edit'.toUpperCase(),
                                    ),
                                  ),
                                )
                              ],
                            );
                    },
                  )
                ],
              ),
              userProvider.token == ''
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.surfaceVariant),
                            splashColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            onTap: _logout,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: ,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Log out'.toUpperCase(),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          SocialMedia()
        ],
      ),
    );
  }
}

class SocialMedia extends StatelessWidget {
  const SocialMedia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
            splashColor: Colors.blueAccent,
            onTap: () {},
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: ,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.facebook_outlined,
                      color: Colors.grey,
                    ),
                    Text(
                      'Facebook Page'.toUpperCase(),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            overlayColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.surfaceVariant),
            splashColor: Theme.of(context).colorScheme.secondaryContainer,
            onTap: () => {},
            child: Container(
              width: double.infinity,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // color: ,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.messenger_outlined,
                    color: Colors.grey,
                  ),
                  Text(
                    'Messenger'.toUpperCase(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
            splashColor: Colors.lightBlue,
            onTap: () => {},
            child: Container(
              width: double.infinity,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // color: ,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.wechat_outlined,
                    color: Colors.grey,
                  ),
                  Text(
                    'Viber'.toUpperCase(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
