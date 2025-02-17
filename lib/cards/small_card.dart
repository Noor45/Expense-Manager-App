
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SmallCards extends StatefulWidget {
  const SmallCards({super.key, required this.text, this.onTap,});
  final String text;
  final Function? onTap;

  @override
  State<SmallCards> createState() => _SmallCardsState();
}

class _SmallCardsState extends State<SmallCards> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap as void Function()?,
      child: Card(
        elevation: 5,
        child: Container(
          height: 150,
          width: 150,
          // padding: EdgeInsets.only(bottom: 10, left: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5), // Set shadow color and opacity
            //     blurRadius: 10.0, // Apply some blur
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: ColorRefer.kPrimaryColor,
                    fontSize: 18.0,
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
