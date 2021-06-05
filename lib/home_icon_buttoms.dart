import 'package:flutter/material.dart';
import 'package:project/App_store.dart';
import 'package:velocity_x/velocity_x.dart';

class CatigoryW extends StatelessWidget {
  final String image;
  final String text, routname;
  final Color color;
  CatigoryW({this.image, this.text, this.color, this.routname});

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [Create]);
    return InkWell(
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
      onTap: () async {
        var size = MediaQuery.of(context).size;
        double w = size.width;
        double h = size.height;
        Create(w, h);
        await Navigator.pushNamed(context, routname);
      },
    );
  }
}
