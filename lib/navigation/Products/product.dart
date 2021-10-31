import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_vinted_app/theme/light_color.dart';
import 'package:fake_vinted_app/widget/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatefulWidget {
  final String productId;

  // In the constructor, require a Todo.
  const ProductScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin {
  late List<dynamic> imgList;
  late String productBrand;
  late String productName;
  late String productSize;
  late double productPrice;
  late String productDescription;
  late String productType;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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

          imgList = data["productImages"];
          productBrand = data["productBrand"];
          productName = data["productName"];
          productDescription = data["productDescription"];
          productType = data["productType"];
          productPrice = data["productPrice"];
          productSize = data["productSize"].toString();

          return Scaffold(
            floatingActionButton: _flotingButton(),
            body: SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color(0xfffbfbfb),
                    Color(0xfff7f7f7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _productImage(),
                        _categoryWidget(),
                      ],
                    ),
                    //_detailWidget()
                  ],
                ),
              ),
            ),
          );

          /*return Container(
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
          );*/

        }

        return Text("loading");
      },
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: LightColor.red,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Image.network(
            imgList[0],
            width: MediaQuery.of(context).size.width / 1.5,
          )
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 15.0,
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.map((x) => _thumbnail(x)).toList(),
      ),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      //  builder: null,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: Duration(milliseconds: 500),
        child: child,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 60,
          width: 75,
          decoration: BoxDecoration(
            border: Border.all(
              color: LightColor.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            //color: Theme.of(context).backgroundColor,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(13.0),
              child: Image.network(image)),
        ).ripple(() {},
            borderRadius: const BorderRadius.all(Radius.circular(13))),
      ),
    );
  }
}
