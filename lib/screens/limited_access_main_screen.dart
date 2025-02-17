import 'package:expense_wallet/screens/add_expences.dart';
import 'package:expense_wallet/screens/dashboard_screen.dart';
import 'package:expense_wallet/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../auth/login.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets//dialogs.dart';


class LimitedAccessMainScreen extends StatefulWidget {
  static String mainScreenID = "/limited_access_main_screen_screen";

  const LimitedAccessMainScreen({super.key});
  @override
  _LimitedAccessMainScreenState createState() => _LimitedAccessMainScreenState();
}

class _LimitedAccessMainScreenState extends State<LimitedAccessMainScreen> {
  GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  int _selectedIndex = 0;
  bool showSpinner = false;
  bool business = false;
  bool general = false;
  final List<dynamic> tabs = [
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    setState(() {
      Constants.typeExpense!.forEach((element) {
        if(element.expenseTypeId == 1 && element.status == 1) {
          general = true;
        }
        if(element.expenseTypeId == 2 && element.status == 1) {
          business = true;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: _selectedIndex != 0 ?
      AppBar(
          toolbarHeight: 60,
          backgroundColor: ColorRefer.kPrimaryColor,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            color: _selectedIndex == 0
                ? Colors.white
                : ColorRefer.kPrimaryColor,
          ),
          title: Text(
            _selectedIndex == 1 ? "Income" : _selectedIndex == 3 ? "Analytics" :  _selectedIndex == 4 ? "Profile" : '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          actions: _selectedIndex == 2 ?
          [
            IconButton(
              icon: const Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.black
              ),
              onPressed: (){
                showDialogAlert(
                  context: context,
                  title: 'Logout',
                  message: 'Are you sure you want to logout now?',
                  actionButtonTitle: 'Logout',
                  cancelButtonTitle: 'Cancel',
                  actionButtonTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  cancelButtonTextStyle: const TextStyle(
                    color: Colors.black45,
                  ),
                  actionButtonOnPressed: () async{
                    clear();
                    await SessionManager().remove("user_id");
                    await SessionManager().remove("user_detail");
                    Navigator.pushNamedAndRemoveUntil(context, SignInScreen.signInScreenID, (Route<dynamic> route) => false);
                  },
                  cancelButtonOnPressed: (){
                    Navigator.pop(context);
                  },
                );
              },
            )
          ] : []
      ) : null,
      floatingActionButton: Visibility(
        visible: business == false && general == false ? false: true,
        child: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, AddExpenses.addExpenseScreenID);
            // Navigator.pushNamed(context, ViewBankTransactionList.viewBankTransactionScreenID);
          },
          backgroundColor: ColorRefer.kPrimaryColor,
          tooltip: 'Add Transaction',
          elevation: 4.0,
          child: const Icon(Icons.add),
        ),
      ),
      body: tabs[_selectedIndex],
      // bottomNavigationBar: Theme(
      //   data: Theme.of(context).copyWith(
      //     canvasColor: Colors.white,
      //     primaryColor: ColorRefer.kPrimaryColor,
      //   ),
      //   child: BottomNavigationBar(
      //     key: globalKey,
      //     currentIndex: _selectedIndex,
      //     unselectedItemColor: ColorRefer.kGreyColor,
      //     selectedItemColor: ColorRefer.kPrimaryColor,
      //     selectedFontSize: 12,
      //     unselectedFontSize: 12,
      //     type: BottomNavigationBarType.fixed,
      //     items: [
      //       BottomNavigationBarItem(
      //           icon: Padding(
      //             padding: const EdgeInsets.only(top: 3, bottom: 3),
      //             child: Icon(Icons.home_rounded,
      //                 color: _selectedIndex == 0
      //                     ? ColorRefer.kPrimaryColor
      //                     : ColorRefer.kGreyColor),
      //           ),
      //           label: 'Home'),
      //       // BottomNavigationBarItem(
      //       //     icon: Padding(
      //       //       padding: const EdgeInsets.only(top: 3, bottom: 3),
      //       //       child: Icon(Icons.account_balance,
      //       //           color: _selectedIndex == 1
      //       //               ? ColorRefer.kPrimaryColor
      //       //               : ColorRefer.kGreyColor),
      //       //     ),
      //       //     label: 'Banks'),
      //       //
      //       // const BottomNavigationBarItem(
      //       //     icon: Padding(
      //       //       padding: EdgeInsets.only(top: 3, bottom: 3),
      //       //       child: Text(''),
      //       //     ),
      //       //     label: ''),
      //       // BottomNavigationBarItem(
      //       //     icon: Padding(
      //       //       padding: const EdgeInsets.only(top: 3, bottom: 3),
      //       //       child: Icon(Icons.bar_chart,
      //       //           color: _selectedIndex == 3
      //       //               ? ColorRefer.kPrimaryColor
      //       //               : ColorRefer.kGreyColor),
      //       //     ),
      //       //     label: 'Analytics'),
      //
      //       BottomNavigationBarItem(
      //           icon: Padding(
      //             padding: const EdgeInsets.only(top: 3, bottom: 3),
      //             child: Icon(Icons.person,
      //                 color: _selectedIndex == 4
      //                     ? ColorRefer.kPrimaryColor
      //                     : ColorRefer.kGreyColor),
      //           ),
      //           label: 'Profile'),
      //     ],
      //
      //     onTap: (index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     },
      //   ),
      // ),
    );
  }




}

// class ProfileImageWithStatus extends StatelessWidget {
//   // ... other properties like imageUrl, isOnline
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(90),
//       child: SizedBox(
//         width: 80,
//         height: 80,
//         child: CustomPaint(
//           painter: ProfileImagePainter(
//             isOnline: true, // Replace with your status logic
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfileImagePainter extends CustomPainter {
//
//   final bool isOnline;
//
//   ProfileImagePainter({required this.isOnline});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     ClipRRect (
//       borderRadius: BorderRadius.circular(90),
//       child: Constants.userDetail?.profileImageUrl == null ||
//           Constants.userDetail?.profileImageUrl == '' ?
//       Image.asset(
//         StringRefer.user,
//         width: 80,
//         height: 80,
//         fit: BoxFit.fill,
//       ) :
//       FadeInImage.assetNetwork(
//         image: '${StringRefer.profileImagePath}${Constants.userDetail?.profileImageUrl as String}',
//         width: 40,
//         height: 40,
//         fit: BoxFit.fill,
//         placeholder: StringRefer.user,
//       ),
//     );
//
//     // Draw the status indicator
//     if (isOnline) {
//       final paint = Paint()..color = Colors.green;
//       final radius = size.width * 0.15; // Adjust for desired size
//       final offset = Offset(size.width - radius, size.height - radius);
//       canvas.drawCircle(offset, radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }



//
// class MainScreen extends StatefulWidget {
//   static String mainScreenID = "/main_screen_screen";
//   const MainScreen({super.key});
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//  final _controller = PersistentTabController(initialIndex: 0);
//  List<Widget> _buildScreens(){
//    return [
//      const DashboardScreen(),
//      const ViewIncomelist(),
//      const AddExpenses(),
//      const Text("message"),
//      const ProfileScreen(),
//    ];
//  }
//  List<PersistentBottomNavBarItem> _navBarsItems() {
//    return [
//      PersistentBottomNavBarItem(
//        icon: const Icon(Icons.home),
//        title: ("Home"),
//        activeColorPrimary: ColorRefer.kPrimaryColor,
//        inactiveColorPrimary: Colors.grey,
//        ),
//      PersistentBottomNavBarItem(
//          icon: const Icon(Icons.account_balance),
//          title: ("Income"),
//        activeColorPrimary: ColorRefer.kPrimaryColor,
//        inactiveColorPrimary: Colors.grey,
//      ),
//      PersistentBottomNavBarItem(
//          icon: const Icon(Icons.add,color: Colors.black,),
//        activeColorPrimary: ColorRefer.kPrimaryColor,
//      ),
//      PersistentBottomNavBarItem(
//          icon: const Icon(Icons.bar_chart),
//        activeColorPrimary: ColorRefer.kPrimaryColor,
//        inactiveColorPrimary: Colors.grey,
//          title: ("Analytics"),
//      ),
//      PersistentBottomNavBarItem(
//          icon: const Icon(Icons.person),
//        activeColorPrimary: ColorRefer.kPrimaryColor,
//        inactiveColorPrimary: Colors.grey,
//        title: ("Profile"),
//      ),
//    ];
//  }
//
//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       backgroundColor: Colors.white, // Default is Colors.white.// Default is true.
//       decoration: NavBarDecoration(
//         borderRadius: BorderRadius.circular(1),
//       ),
//       navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
//     );
//   }
// }




