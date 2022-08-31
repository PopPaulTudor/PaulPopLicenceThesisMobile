import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:licenta/pages/home/home_screen.dart';
import 'package:licenta/pages/login/login_view_model.dart';
import 'package:licenta/pages/register/register_page.dart';
import 'package:licenta/theme/app_colors.dart';
import 'package:licenta/theme/bottom_curve_painter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:licenta/models/subscription_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: AppColors.secondaryColor));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raoul',
      ),
      home: DecisionScreen(),
    );
  }
}

class DecisionScreen extends StatefulWidget {
  const DecisionScreen({Key? key}) : super(key: key);

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends SubscriptionState<DecisionScreen> {

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      if (value.getString("email") != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
    }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends SubscriptionState<LoginScreen> {
  late LoginViewModel _viewModel;
  String email = "";
  String? emailError;
  String password = "";
  String? passwordError;

  @override
  void initState() {
    _viewModel = LoginViewModel(
      Input(
        PublishSubject(),
      ),
    );
    _bindViewModel();
    super.initState();
  }

  void _bindViewModel() {
    disposeLater(_viewModel.output.onLoginAnswer.listen((event) {
      Navigator.pop(context);
      if (event) {
        _goToHomeScreen();
      } else {
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
                        SizedBox(
                          height: 15,
                        ),
                        // Some text
                        Text(
                            'Error at login')
                      ],
                    ),
                  ));
            });
      }
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
          ListView(
            children: [
              Container(
                height: 200,
                width: 200,
                margin: EdgeInsets.only(top: 15, bottom: 50),
                child: SvgPicture.asset("assets/login.svg",
                    semanticsLabel: 'Login'),
              ),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    "Traveling just got\n   a lot easier",
                    style: TextStyle(
                      fontSize: 30,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Login and book your next journey",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
              Padding(
                padding:
                const EdgeInsets.only(top: 20.0, left: 100, right: 100),
                child: ElevatedButton(
                  onPressed: () => onCheckData(),
                  child: Text("Login"),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(AppColors.primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _goToRegisterScreen(),
                child: Text(
                  "Register into your first journey",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onCheckData() {
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
    });

    if (isValid) {
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
                      Text(
                          'Traveling far with the data')
                    ],
                  ),
                ));
          });
      _viewModel.input.onLoginRequested.add(LoginData(email, password));
    }
  }

  _goToRegisterScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

  _goToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }
}
