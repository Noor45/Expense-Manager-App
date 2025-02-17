import 'package:flutter/material.dart';
import '../screens/add_income.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({super.key, required this.text, required this.amount, this.onTap, this.imagePath, required this.id, required this.index});
  final int id;
  final String text;
  final int amount;
  final Function? onTap;
  final String? imagePath;
  final int index;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,bottom: 20,right: 20),
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Container(
          width: 400,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Set a circular radius of 10 pixels
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
                      child: Image.network("${StringRefer.imagesPath}bank/${widget.imagePath}"),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25,),
                        Text( widget.text, style: const TextStyle(fontFamily: FontRefer.OpenSans,fontWeight: FontWeight.w800,),),
                        Text('RS ${widget.amount.toString()}', style: const TextStyle(fontSize: 15),),
                      ],
                    ),
                  ],
                ),

                // const SizedBox(width: 110,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                AddIncome(
                                  id: Constants.bankList![widget.index].id!,
                                  bankName: Constants.bankList![widget.index].bankName!,
                                )
                        )
                    );
                  },
                  child: Container(
                    width:40,
                    height:40,
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(25)),
                        color: ColorRefer.kPrimaryColor),
                    child: const Icon( Icons.add,
                      color: Colors.black, size: 20,
                    ),
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
