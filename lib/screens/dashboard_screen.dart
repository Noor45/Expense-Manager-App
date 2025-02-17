import 'package:expense_wallet/controller/type_expense_controller.dart';
import 'package:expense_wallet/pages/business_Itmes.dart';
import 'package:expense_wallet/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/general_Items.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';



 class DashboardScreen extends StatefulWidget {
   const DashboardScreen({super.key});

   @override
   State<DashboardScreen> createState() => _DashboardScreenState();
 }

 class _DashboardScreenState extends State<DashboardScreen> {
   String companyName = '';
   String companyLogo = '';
   int general = 1;
   int business = 2;
   @override
  void initState() {
    setState(() {
      for (var element in Constants.companyList!) {
        if(Constants.companyId == element.id) {
          companyName = element.name!;
          companyLogo = element.logo!;
        }
      }
    });
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
     print(companyLogo);
     return SafeArea(
       child: Scaffold(
         backgroundColor: Colors.white,
         body: Column(
           children: [
             Padding(
               padding: const EdgeInsets.only(left: 15,top: 15,right: 15),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Container(
                     width: MediaQuery.of(context).size.width/1.5,

                     child: Text(companyName,
                       style: const TextStyle(
                           fontSize: 20,
                           fontFamily: FontRefer.OpenSans,
                           color: ColorRefer.kSecondary1Color,
                           fontWeight: FontWeight.bold),
                     ),
                   ),
                   GestureDetector(
                     onTap: (){
                       ExpenseController.getStats();
                       if(Constants.userDetail!.access! != 1){
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => const ProfileScreen(),
                           ),
                         );
                       }
                     },
                     child: CircleAvatar(
                       radius: 25,
                       child: companyLogo.isEmpty == false  ?
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: FadeInImage.assetNetwork(
                           image: '${StringRefer.imagesPath}company/$companyLogo',
                           fit: BoxFit.fill,
                           placeholder: StringRefer.user,
                         ),
                       ) : Image.asset("assets/images/user.png"),
                     ),
                   )
                 ],
               ),
             ),
             Constants.userDetail!.access! == 1 ? Padding(
               padding: const EdgeInsets.only(top: 50),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   GestureDetector(
                     onTap: () {},
                     child: Container(
                       width: 165,
                       height: 70,
                       decoration: BoxDecoration(
                         color: Colors.red,
                         borderRadius: BorderRadius.circular(25),
                       ),
                       margin: const EdgeInsets.only(left: 5),
                       child: Row(
                         children: [
                           const SizedBox(width: 5),
                           const CircleAvatar(
                             child: Icon(Icons.arrow_upward_outlined,
                             ),
                           ),
                           const SizedBox(width: 5),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const SizedBox(height: 5,),
                               const Text("Expense",
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontFamily: FontRefer.OpenSans,
                                   color: Colors.white,
                                 ),
                               ),
                               const SizedBox(height: 5),
                               Text('Rs. ${Constants.spend == 0 ? '0.00' : moneyFormat(Constants.spend.toString())}',style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold
                               ),),
                             ],
                           )
                         ],
                       ),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {},
                     child: Container(
                       width: 165,
                       height: 70,
                       decoration: BoxDecoration(
                         color: Colors.green,
                         borderRadius: BorderRadius.circular(25),
                       ),
                       margin: const EdgeInsets.only(right: 5),
                       child: Row(
                         children: [
                           const SizedBox(width: 10),
                           const CircleAvatar(
                             child: Icon(Icons.arrow_downward_outlined),
                           ),
                           const SizedBox(width: 5),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const SizedBox(height: 5,),
                               const Text("Income",
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontFamily: FontRefer.OpenSans,
                                   color: Colors.white,
                                 ),
                               ),
                               const SizedBox(height: 5,),
                               Text('Rs. ${Constants.income == 0 ? '0.00' : moneyFormat(Constants.income.toString())}',style: const TextStyle(
                                 color: Colors.white,
                                 fontSize: 16,
                                 fontWeight: FontWeight.bold
                               ),),
                             ],
                           )
                         ],
                       ),
                     ),
                   )
                 ],
               ),
             ) : const SizedBox(),
             const SizedBox(height: 20),
             Expanded(
               child: ListView.builder(
                 physics: const NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemCount: Constants.typeExpense!.length,
                 itemBuilder: (BuildContext context, int index) {
                   int expenseId = Constants.typeExpense![index].expenseTypeId!;
                    if(Constants.typeExpense![index].expenseTypeId! == 1){
                      general = Constants.typeExpense![index].expenseTypeId!;
                    }else{
                      business = Constants.typeExpense![index].expenseTypeId!;
                    }
                   return Column(
                     children: [
                       general == 1 &&  Constants.typeExpense![index].status == 1  && business == 2 &&  Constants.typeExpense![index].status == 1
                           ? Padding(
                         padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                         child: index == 0  ? const Text('Activate your expense category from your company portal !', style: TextStyle(fontSize: 14, color: Colors.orange)) : SizedBox(),
                       ) : const SizedBox(),
                       Visibility(
                         visible: Constants.typeExpense![index].status! == 0 ? true : false,
                         child: ExpenceCard(
                           text: Constants.typeExpense![index].expenseName!,
                           onTap: () {
                             if (expenseId == 1) {
                               Navigator.of(context).push(
                                   MaterialPageRoute(
                                       builder: (context) =>
                                           GeneralItems(
                                             expenseType: Constants.typeExpense![index].expenseName!,
                                             expenseId: expenseId,
                                           )
                                   )
                               );
                             } else if (expenseId == 2) {
                               Navigator.of(context).push(
                                   MaterialPageRoute(
                                       builder: (context) =>
                                           BusinessItems(
                                             expenseType: Constants.typeExpense![index].expenseName!,
                                             expenseId: expenseId,
                                           )
                                   )
                               );
                             } else {
                               // Handle other IDs if needed
                             }
                           },
                         ),
                       ),
                     ],
                   );
                 },
               ),
             ),
           ],
         ),
       ),
     );
   }
 }

class ExpenceCard extends StatefulWidget {
  const ExpenceCard({super.key, required this.text,  required this.onTap,});
  final String text;
   final Function? onTap;

  @override
  State<ExpenceCard> createState() => _ExpenceCardState();
}

class _ExpenceCardState extends State<ExpenceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,bottom: 15,right: 15),
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        child: Container(
          width: 400,
          height: 100,
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
          child: Padding(
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
                const Icon(Icons.arrow_forward_ios_outlined,
                  color: ColorRefer.kGreyColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}