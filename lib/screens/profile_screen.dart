import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/ImagePicker.dart';
import '../auth/login.dart';
import '../auth/option_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';
import '../widgets/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final picker = ImagePicker();
  Color borderColor = Colors.transparent;
  File? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController accessController = TextEditingController();

  void pickImage(ImageSource imageSource) async {
    XFile? galleryImage = await picker.pickImage(source: imageSource);
    setState(() {
      image = File(galleryImage!.path);
    });
  }

  @override
  void initState() {
    nameController.text = Constants.userDetail!.name!;
    emailController.text = Constants.userDetail!.email!;
    if( Constants.userDetail!.access! == 1){
      accessController.text = 'Full Access';
    }
    else if( Constants.userDetail!.access! == 2){
      accessController.text = 'Moderate Access';
    }
    else if( Constants.userDetail!.access! == 3){
      accessController.text = 'Limited Access';
    }else{
      accessController.text = 'No Access';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Constants.userDetail!.access!);
    return Scaffold(
      appBar: Constants.userDetail!.access! == 1 ?
      AppBar(
          toolbarHeight: 60,
          backgroundColor: ColorRefer.kPrimaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text(
             "Profile" ,
            style:  TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          actions: [
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
                    // Navigator.pushNamedAndRemoveUntil(context, SignInScreen.signInScreenID, (Route<dynamic> route) => false);
                    Navigator.pushNamedAndRemoveUntil(context, OptionScreen.ID, (Route<dynamic> route) => false);
                  },
                  cancelButtonOnPressed: (){
                    Navigator.pop(context);
                  },
                );
              },
            )
          ]
      ) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // showImageDialogBox();
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 125,
                            width: 125,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor),
                            ),
                            child: image != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ) :
                            Constants.userDetail?.image != null && Constants.userDetail?.image!.isEmpty == false  ?
                            ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              child: FadeInImage.assetNetwork(
                                image: '${StringRefer.imagesPath}users/${Constants.userDetail?.image}',
                                fit: BoxFit.cover,
                                placeholder: StringRefer.user,
                              )) : SvgPicture.asset('assets/icons/person.svg'),
                          ),
                          // Positioned(
                          //   left: 90,
                          //   bottom: 10,
                          //   child: SvgPicture.asset(
                          //     'assets/icons/camera.svg',
                          //     width: 30,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "USERNAME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorRefer.kLabelColor,
                      fontFamily: FontRefer.OpenSans,
                    ),
                  ),
                  TextFormField(
                    enabled: false,
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: ColorRefer.kLabelColor,
                          fontFamily: FontRefer.OpenSans,
                        )
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "EMAIL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorRefer.kLabelColor,
                      fontFamily: FontRefer.OpenSans,
                    ),
                  ),
                  TextFormField(
                    enabled: false,
                    controller: emailController,
                    decoration:  InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: ColorRefer.kLabelColor,
                          fontFamily: FontRefer.OpenSans,
                        )
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "ACCESS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorRefer.kLabelColor,
                      fontFamily: FontRefer.OpenSans,
                    ),
                  ),
                  TextFormField(
                    enabled: false,
                    controller: accessController,
                    decoration:  InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: ColorRefer.kLabelColor,
                          fontFamily: FontRefer.OpenSans,
                        )
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Text(
                  //   "Type",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: ColorRefer.kLabelColor,
                  //     fontFamily: FontRefer.OpenSans,
                  //   ),
                  // ),
                  // TextFormField(
                  //   enabled: false,
                  //   decoration:  InputDecoration(
                  //       hintText: "Write here...",
                  //       hintStyle: TextStyle(
                  //         color: ColorRefer.kLabelColor,
                  //         fontFamily: FontRefer.OpenSans,
                  //       )
                  //   ),
                  // ),
                  const SizedBox(height: 15)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showImageDialogBox() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color(0xFF737373),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: CameraGalleryBottomSheet(
              cameraClick: () => pickImage(ImageSource.camera),
              galleryClick: () => pickImage(ImageSource.gallery),
            ),
          ),
        );
      },
    );
  }
}
