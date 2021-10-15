import 'package:flutter/material.dart';

class Acheter extends StatefulWidget {
  const Acheter({Key? key}) : super(key: key);

  @override
  __AcheterState createState() => __AcheterState();
}

class __AcheterState extends State<Acheter> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: List.generate(50, (index) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(
              top: 20.0, bottom: 15.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          //child: Card(),
        );
      }),
    );
  }
}
