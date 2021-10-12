import 'package:fake_vinted_app/navigation/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  __ProfilState createState() => __ProfilState();
}

class __ProfilState extends State<Profil> {
  bool profilEdit = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red, width: 4),
        color: Colors.red[50],
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _buildModificationButton(),
                _buildInformationField(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildLogout(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModificationButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (profilEdit == false) {
                  profilEdit = true;
                } else {
                  profilEdit = false;
                }
              });
            },
            child: profilEdit
                ? Icon(Icons.check, color: Colors.white)
                : Icon(Icons.create, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInformationField() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            child: const TextField(
              //controller: _emailControler,
              enabled: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              enabled: profilEdit,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              enabled: profilEdit,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Anniversaire',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              enabled: profilEdit,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Adresse',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              enabled: profilEdit,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Code Postal',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              enabled: profilEdit,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Ville',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 20.0, left: 40.0, right: 40.0),
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
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginForm()));
                      } else {
                        print('User is signed in!');
                      }
                    });
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
