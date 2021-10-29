import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Acheter extends StatefulWidget {
  const Acheter({Key? key}) : super(key: key);

  @override
  __AcheterState createState() => __AcheterState();
}

class __AcheterState extends State<Acheter> {
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('Products').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.center,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(10.0)),
                    width: 300.0,
                    height: 200.0,
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Center(
                          child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: CircularProgressIndicator(
                              value: null,
                              strokeWidth: 7.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: const Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),*/
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 2,
                    )),
                child: InkWell(
                  splashColor: Colors.red.withAlpha(30),
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Image.network(
                          data["productImages"][0],
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data["productBrand"],
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                                data["productName"] +
                                    " (" +
                                    data["productSize"].toString() +
                                    ")",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                textAlign: TextAlign.left),
                            Text(
                              data["productPrice"].toString() + "€",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.red,
                          icon: const Icon(
                            Icons.shopping_cart,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
