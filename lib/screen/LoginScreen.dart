import 'package:flutter/material.dart';
import 'package:flutter_youtube_watcher/data/shared_prefs.dart';
import 'package:flutter_youtube_watcher/screen/home_screen.dart';
import 'package:flutter_youtube_watcher/ui/regex_control.dart';

import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool autoValidate = false;
  final formKey = GlobalKey<FormState>();
  var mailController = TextEditingController();
  var passwordController = TextEditingController();
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Youtube Watcher")),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Colors.amber.withOpacity(0.2),
                Colors.amber.withOpacity(0.2),
                Colors.amber.withOpacity(0.2),
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.5),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidate: autoValidate,
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5),
                          //Mail
                          myTextFormField("E-Mail", Icons.mail, mailController,
                              RegexKontrol.mailKontrol),
                          SizedBox(height: 15),
                          //Password
                          myTextFormField(
                            "Şifre",
                            Icons.lock,
                            passwordController,
                            RegexKontrol.passwordControl,
                          ),
                          SizedBox(height: 15),
                          _loginButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Ortak kullanılan text form field
  Widget myTextFormField(
    String labelText,
    IconData iconData,
    TextEditingController controller,
    Function function,
  ) {
    return TextFormField(
      validator: function,
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(
            iconData,
            size: 35,
            color: Colors.black,
          ),
          border: OutlineInputBorder()),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: double.infinity,
      child: RaisedButton(
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        onPressed: () {
          autoValidate = true;
          if (formKey.currentState.validate()) {
            //Form kontrolleri doğru ise gerekli bilgileri telefon hafızasına kayıt ediyoruz.
            formKey.currentState.save();
            SharedPrefs.saveMail(mailController.text);
            SharedPrefs.savePassword(passwordController.text);
            SharedPrefs.login();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        mailController.text, passwordController.text)));
          }
        },
        child: Text(
          "Login",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ),
    );
  }
}
