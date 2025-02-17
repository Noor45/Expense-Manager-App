
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';




class VerticalCard extends StatefulWidget {
  const VerticalCard({super.key, required this.text, this.onTap});
  final String text;
  final Function? onTap;

  @override
  State<VerticalCard> createState() => _VerticalCardState();
}

class _VerticalCardState extends State<VerticalCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,bottom: 15,right: 15),
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Container(
          width: 400,
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Set a circular radius of 10 pixels
            border: const Border(
              left: BorderSide(
                color: ColorRefer.kSecondary1Color, // Set line color
                width: 3.0, // Adjust line width
              ),

            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Set shadow color and opacity
                offset: const Offset(4.0, 4.0), // Offset the shadow right-bottom
                blurRadius: 5.0, // Apply some blur
              ),
            ],
          ),
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: FontRefer.OpenSans,
                    color: ColorRefer.kGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}