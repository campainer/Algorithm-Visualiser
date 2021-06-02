import 'package:flutter/material.dart';

class CatigoryW extends StatelessWidget {
  final String image;
  final String text,routname;
  final Color color;
  CatigoryW({this.image, this.text, this.color,this.routname});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0x9F3D416E),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 120,
              height: 120,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 18),
            ),
          ],
        ),
      ),
      onTap: () {Navigator.pushNamed(context, routname);},
    );
  }
}
