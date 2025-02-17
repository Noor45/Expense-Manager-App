import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';


class ManagementCards extends StatefulWidget {
  const ManagementCards({super.key, required this.text, this.onTap, this.imagePath, });
  final String text;
  final Function? onTap;
  final String? imagePath;
  @override
  State<ManagementCards> createState() => _ManagementCardsState();
}

class _ManagementCardsState extends State<ManagementCards> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 15,bottom: 15,right: 15,),
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Container(
          width: 400,
          height: 55,
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
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      child: widget.imagePath != null && widget.imagePath != 'NULL' ? Image.network("${StringRefer.imagesPath}employees/${widget.imagePath}") : SvgPicture.asset('assets/icons/person.svg'),
                    ),
                    const SizedBox(width: 10,),
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
                const Icon(Icons.arrow_forward_ios_outlined,
                  color: ColorRefer.kGreyColor, size: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
