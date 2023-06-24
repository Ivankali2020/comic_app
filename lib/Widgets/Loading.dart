import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  final String title;
  final double width;
  final double heght;
  final double fontSize;
  // late Color color = Color.fromARGB(255, 244, 244, 244);
  const Loading(this.title, this.width, this.heght, this.fontSize, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heght,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Color.fromARGB(255, 244, 244, 244),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}