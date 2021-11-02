import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_vinted_app/services/cart_service.dart';
import 'package:flutter/material.dart';

class Panier extends StatefulWidget {
  const Panier({Key? key}) : super(key: key);

  @override
  __PanierState createState() => __PanierState();
}

class __PanierState extends State<Panier> {
  @override
  Widget build(BuildContext context) {
    //return const Center(child: Text("Panier"));
    return Scaffold(
      body: _generateCart(),
    );
  }

  _generateCart() {
    return StreamBuilder<QuerySnapshot>(
      stream: CartService().getPanier(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Image.network(
                        data["image"],
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data["marque"],
                            style: const TextStyle(
                                color: Colors.red, fontSize: 18),
                            textAlign: TextAlign.left,
                          ),
                          Text(data["nom"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.left),
                          Text(
                            "Prix Unitaire: " +
                                data["prix"].toStringAsFixed(2) +
                                "\$",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                          ),
                          Text(
                            "Quantité: " + data["quantite"].toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        onPressed: () {
                          CartService().supprimerArticlePanier(data["id"]);
                          showRemoveFromCartBanner();
                        },
                        color: Colors.red,
                        icon: const Icon(
                          Icons.cancel,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void showRemoveFromCartBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Article supprimer du panier.',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        backgroundColor: Colors.red[100],
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.red,
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }
}
