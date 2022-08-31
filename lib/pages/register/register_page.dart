import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:licenta/models/subscription_state.dart';
import 'package:licenta/models/ui_model.dart';
import 'package:licenta/pages/home/home_screen.dart';
import 'package:licenta/pages/register/register_view_model.dart';
import 'package:licenta/theme/app_colors.dart';
import 'package:licenta/theme/bottom_curve_painter.dart';
import 'package:licenta/theme/inverted_painter.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends SubscriptionState<RegisterPage> {
  late RegisterViewModel _viewModel;
  List<Uint8List> images = [];
  String email = "paul@gmail.com";
  String password = "1234";
  String phoneNumber = "1234";
  String passwordAgain = "1234";
  String? emailError;
  String? passwordError;
  String? phoneError;

  @override
  void initState() {
    _viewModel = RegisterViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
      ),
    );
    _bindViewModel();
    super.initState();
  }

  void _bindViewModel() {
    disposeLater(_viewModel.output.onLoginAnswer.listen((event) {
      if (event.state == OperationState.success) {
        _viewModel.input.onRequestPhotos
            .add(CreateAccountData(email, password, phoneNumber, images));
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) {
              return Dialog(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // The loading indicator
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15,
                        ),
                        // Some text
                        Center(
                          child: Text(
                              'Profile created successfully.\nGenerating your profile'),
                        )
                      ],
                    ),
                  ));
            });
      }
    }));

    disposeLater(_viewModel.output.onProfileFinished.listen((event) {
      Navigator.pop(context);
      String tags = event;
      tags = tags.substring(0, tags.length - 2);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Your tags are: " + tags),
      ));
      _goToHomeScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: BottomCurvePainter(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: InvertedPainter(),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: SvgPicture.asset("assets/register.svg",
                    semanticsLabel: 'Register'),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListView(children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32,
                        top: 32,
                      ),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            email = text;
                          });
                        },
                        decoration: InputDecoration(
                          focusColor: AppColors.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          labelText: 'Email',
                          errorText: emailError,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32,
                        top: 16,
                        bottom: 16,
                      ),
                      child: TextField(
                        obscureText: true,
                        onChanged: (text) {
                          setState(() {
                            password = text;
                          });
                        },
                        decoration: InputDecoration(
                          focusColor: AppColors.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          labelText: 'Password',
                          errorText: passwordError,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32,
                        top: 16,
                        bottom: 16,
                      ),
                      child: TextField(
                        obscureText: true,
                        onChanged: (text) {
                          setState(() {
                            passwordAgain = text;
                          });
                        },
                        decoration: InputDecoration(
                          focusColor: AppColors.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          labelText: 'Password again',
                          errorText: passwordError,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32,
                        bottom: 32,
                      ),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            phoneNumber = text;
                          });
                        },
                        decoration: InputDecoration(
                          focusColor: AppColors.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          labelText: 'Phone number',
                          errorText: phoneError,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 100, right: 100),
                      child: ElevatedButton(
                        onPressed: () {
                          _register();
                        },
                        child: Text("Create account"),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 100, right: 100),
                      child: ElevatedButton(
                        onPressed: () => _uploadPhotos(),
                        child: Text(
                          "Upload 4 photos",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                      ),
                    ),
                    images.length == 4
                        ? SizedBox(
                            height: 500,
                            child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                crossAxisCount: 3,
                                children: images
                                    .map((element) => Image.memory(element))
                                    .toList()),
                          )
                        : Container(),
                  ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _uploadPhotos() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> ximages = (await _picker.pickMultiImage())!;
    if (ximages.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please upload exactly 4 photos"),
      ));
    } else {
      images.clear();
      for (var element in ximages) {
        element.readAsBytes().asStream().listen((event) {
          setState(() {
            images.add(event);
          });
        });
      }
    }
  }

  void _register() {
    bool isValid = true;
    setState(() {
      if (email.isEmpty) {
        emailError = "Email  can not be empty";
        isValid = false;
      } else {
        emailError = null;
      }

      if (password.isEmpty) {
        passwordError = "Password can not be empty";
        isValid = false;
      } else {
        passwordError = null;
      }

      if (password != passwordAgain) {
        passwordError = "Passwords does not match";
        isValid = false;
      } else {
        passwordError = null;
      }
      if (phoneNumber.isEmpty) {
        phoneError = "Phone number can not be empty";
        isValid = false;
      } else {
        phoneError = null;
      }
      if (images.length != 4) {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please upload 4 photos"),
        ));
      }
    });

    if (isValid) {
      _viewModel.input.onCreateAccount
          .add(CreateAccountData(email, password, phoneNumber, images));
    }
  }

  _goToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }
}
