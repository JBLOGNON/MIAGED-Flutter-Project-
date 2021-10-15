import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_vinted_app/navigation/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();

  var hidePassword = true;
  var hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Miaged",
            style: TextStyle(fontFamily: 'Roulette', fontSize: 50),
            textAlign: TextAlign.center),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: <Widget>[
            _buildRegisterText(),
            _buildInputField(),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: const <Widget>[
          Text("Sing Up, \n Please fill the form with your informations",
              style: TextStyle(fontSize: 20), textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _email,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _password,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: const Icon(Icons.visibility),
                ),
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: hidePassword,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _passwordConfirmation,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hideConfirmPassword = !hideConfirmPassword;
                    });
                  },
                  icon: const Icon(Icons.visibility),
                ),
                labelText: 'Confirm Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3, color: Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: hideConfirmPassword,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 0.98,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Colors.red),
              label: const Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              icon: const Icon(Icons.login),
              onPressed: _signupPressed,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _signupPressed() async {
    if (_password.text == _passwordConfirmation.text) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);

        var currentUser = FirebaseAuth.instance.currentUser;

        Future<void> users = FirebaseFirestore.instance
            .collection('UserInformations')
            .doc(currentUser!.uid)
            .set({
          'Adress': 'Entrez une adresse',
          'Birthday': DateTime.now(),
          'City': 'Entrez une ville',
          'Postal': 'Entrez un code postal',
        });

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginForm()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showMyDialog('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showMyDialog('The account already exists for that email.');
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      showMyDialog("Passwords does not match, please try again");
    }
  }

  Future<void> showMyDialog(String errorText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
