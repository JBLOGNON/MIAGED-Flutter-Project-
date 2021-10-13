import 'package:fake_vinted_app/navigation/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  __ProfilState createState() => __ProfilState();
}

class __ProfilState extends State<Profil> {
  bool profilEdit = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController anniversaireController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference users =
      FirebaseFirestore.instance.collection('UserInformations');

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
      child: SingleChildScrollView(
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
            /*Expanded(
              child:*/
            Container(
              child: Column(
                /*crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,*/
                children: <Widget>[
                  _buildLogout(context),
                ],
              ),
            ),
            //)
          ],
        ),
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
                  saveProfilInformationToFirebase();
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
    var formatter = DateFormat('yyyy-MM-dd');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          //return Text("Ville: ${data['City']}");
          emailController..text = currentUser!.email!;
          //passwordController..text = ;
          anniversaireController
            ..text = "${formatter.format(data['Birthday'].toDate())}";
          adresseController..text = data['Adress'];
          zipCodeController..text = data['Postal'];
          villeController..text = data['City'];
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
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
                      prefixIcon: Icon(Icons.lock),
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
                      controller: anniversaireController,
                      enabled: profilEdit,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Anniversaire',
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        anniversaireController.text =
                            date.toString().substring(0, 10);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: adresseController,
                    enabled: profilEdit,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.home),
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
                    controller: zipCodeController,
                    enabled: profilEdit,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fmd_good),
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
                    controller: villeController,
                    enabled: profilEdit,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Ville',
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );

    /**/
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

  void saveProfilInformationToFirebase() {
    var anniversaire = anniversaireController.text;
    var adresse = adresseController.text;
    var zipcode = zipCodeController.text;
    var ville = villeController.text;

    //Verifier le format de la date

    try {
      users.doc(currentUser!.uid).update({
        //"Birthday": anniversaire,
        "Adress": adresse,
        "Postal": zipcode,
        "City": ville
      });
    } catch (e) {
      //print(e.message);
    }
  }
}
