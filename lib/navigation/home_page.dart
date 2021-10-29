// ignore_for_file: unnecessary_this

import 'package:fake_vinted_app/navigation/acheter.dart';
import 'package:fake_vinted_app/navigation/panier.dart';
import 'package:fake_vinted_app/navigation/profil.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  static bool profilTextFieldEnable = false;

  Widget _Acheter = Acheter();
  Widget _Panier = Panier();
  Widget _Profil = Profil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Miaged",
            style: TextStyle(fontFamily: 'Roulette', fontSize: 50),
            textAlign: TextAlign.center),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Acheter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Panier",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          )
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  void onTapHandler(int index) {
    this.setState(() {
      this.selectedIndex = index;
    });
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _Acheter;
    } else if (selectedIndex == 1) {
      return _Panier;
    } else {
      return _Profil;
    }
  }
}
