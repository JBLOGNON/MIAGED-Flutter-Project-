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
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                //border: Border.all(color: Colors.red, width: 0.5),
                color: Colors.red[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              //child: SingleChildScrollView(
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
                  Container(
                    child: Column(
                      children: <Widget>[
                        _buildLogout(context),
                      ],
                    ),
                  ),
                ],
              ),
              //),
            ),
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
                ? const Icon(Icons.check, color: Colors.white)
                : const Icon(Icons.create, color: Colors.white),
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
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          emailController.text = currentUser!.email!;
          anniversaireController.text =
              formatter.format(data['Birthday'].toDate());
          adresseController.text = data['Adress'];
          zipCodeController.text = data['Postal'];
          villeController.text = data['City'];
          return Container(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                  child: Text(
                    "Account Informations",
                    style: TextStyle(
                        color: Color.fromARGB(255, 117, 117, 117),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                    controller: passwordController,
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
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                  child: Text(
                    "Personal Informations",
                    style: TextStyle(
                        color: Color.fromARGB(255, 117, 117, 117),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
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
                      labelText: 'Birthday',
                    ),
                    onTap: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date == null) {
                        DateTime.now().toString().substring(0, 10);
                      } else {
                        anniversaireController.text =
                            date.toString().substring(0, 10);
                      }
                    },
                  ),
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
                      labelText: 'Adress',
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
                      labelText: 'Zip Code',
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
                      labelText: 'Town',
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      },
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginForm()));
                    /*FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginForm()));
                      } else {
                        // ignore: avoid_print
                        print('User is signed in!');
                      }
                    });*/
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> saveProfilInformationToFirebase() async {
    var anniversaire =
        Timestamp.fromDate(DateTime.parse(anniversaireController.text));
    var adresse = adresseController.text;
    var zipcode = zipCodeController.text;
    var ville = villeController.text;

    try {
      users.doc(currentUser!.uid).update({
        "Birthday": anniversaire,
        "Adress": adresse,
        "Postal": zipcode,
        "City": ville
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if (passwordController.text != '') {
      try {
        await currentUser!.updatePassword(passwordController.text);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    showMyDialog('Your information has successfully been updated.');
  }

  Future<void> showMyDialog(String errorText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulation'),
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
