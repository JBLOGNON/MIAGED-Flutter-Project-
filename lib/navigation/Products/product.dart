import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_vinted_app/theme/light_color.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  final List<dynamic> imgList;
  final String productBrand;
  final String productName;
  final String productSize;
  final num productPrice;
  final String productDescription;
  final String productType;
  // In the constructor, require a Todo.
  const ProductScreen(
      {Key? key,
      required this.productId,
      required this.productBrand,
      required this.productName,
      required this.productSize,
      required this.productPrice,
      required this.productDescription,
      required this.productType,
      required this.imgList})
      : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin {
  List _isHovering = [false, false, false, false, false, false];
  List _isSelected = [true, false, false, false, false, false];

  late AnimationController controller;
  late Animation<double> animation;

  final CarouselController _controller = CarouselController();
  int _current = 0;

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
    return Scaffold(
        floatingActionButton: _flotingButton(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Miaged",
              style: TextStyle(fontFamily: 'Roulette', fontSize: 50),
              textAlign: TextAlign.center),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              _buildCarousel(),
            ],
          ),
        ));
  }

  _buildCarousel() {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: LightColor.red),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 3 / 2,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                    for (var i = 0; i < widget.imgList.length; i++) {
                      if (i == index) {
                        _isSelected[i] = true;
                      } else {
                        _isSelected[i] = false;
                      }
                    }
                  });
                }),
            carouselController: _controller,
          ),
          Center(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width / 4,
                  right: screenSize.width / 4,
                ),
                child: Card(
                  //elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height / 150,
                      bottom: screenSize.height / 150,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < widget.imgList.length; i++)
                          Column(
                            children: [
                              Text(
                                ".",
                                style: TextStyle(fontSize: 30),
                              ),
                              Visibility(
                                visible: _isSelected[i],
                                child: Container(
                                  height: 5,
                                  width: screenSize.width / 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: LightColor.red),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  List<Widget> generateImageTiles(screenSize) {
    return widget.imgList
        .map(
          (element) => ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              element,
              fit: BoxFit.fitWidth,
            ),
          ),
        )
        .toList();
  }
}
