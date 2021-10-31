import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  // In the constructor, require a Todo.
  const ProductScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Miaged",
            style: TextStyle(fontFamily: 'Roulette', fontSize: 50),
            textAlign: TextAlign.center),
      ),
      body: _buildCarousel(),
      /*Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: <Widget>[
            Text(widget.productId),
          ],
        ),
      ),*/
    );
  }

  _buildCarousel() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Products');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.productId).get(),
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

          List<dynamic> imgList = data["productImages"];

          return Container(
            margin: EdgeInsets.all(15),
            child: CarouselSlider.builder(
              itemCount: imgList.length,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: 300,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                reverse: false,
                aspectRatio: 5.0,
              ),
              itemBuilder: (context, i, id) {
                //for onTap to redirect to another screen
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.black,
                        )),
                    //ClipRRect for image border radius
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        imgList[i],
                        //width: 500,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  onTap: () {
                    var url = imgList[i];
                    print(url.toString());
                  },
                );
              },
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
