import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../api/networkUtils.dart';
import '../model/company_model.dart';
import '../screens/privacy_policy.dart';
import '../screens/term_and_condition.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/ImagePicker.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final formKey = GlobalKey<FormState>();
  bool _checkedValue = false;
  late String _name;
  late String _email;
  late String _password;
  late String selectCompany;
  late String _confirmPassword; // New field for confirming password
  bool isLoading = false;
  final picker = ImagePicker();
  Color borderColor = Colors.transparent;
  File? image;

  void pickImage(ImageSource imageSource) async {
    XFile? galleryImage =
    await picker.pickImage(source: imageSource);
    setState(() {
      image = File(galleryImage!.path);
    });
  }

  List<CompanyModel> companyList = Constants.companyList ?? [];
  Map<String, int> companyListModeMap = {
    for (var mode in Constants.companyList ?? [])
      if (mode.name != null) mode.name!: mode.id ?? 0
  };



  Future<void> _registerUser() async{
    try{
      if (!formKey.currentState!.validate()) return;
      if (_password != _confirmPassword) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Passwords do not match.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
      else{
        setState(() {
          isLoading = true;
        });
        if(image != null){
          final response = await NetworkUtil.internal().uploadDataWithImage(
              _name,
              _email,
              _password,
              image!,
              selectCompany
          );
          final output = jsonDecode(response);
          if (output['code'] == 200) {
            setState(() {
              isLoading = false;
            });
            showDialogAlert(
                context: context, title: "Success", actionButtonTextStyle: const TextStyle(color: ColorRefer.kPrimaryColor), message: "Your account have been created successfully", actionButtonTitle: "OK", actionButtonOnPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }
          else {
            setState(() {
              isLoading = false;
              print(output);
            });
            showDialogAlert(
                context: context, title: "Failed", actionButtonTextStyle: const TextStyle(color: ColorRefer.kPrimaryColor), message: output['message'], actionButtonTitle: "OK", actionButtonOnPressed: () {
              Navigator.pop(context);
            });
          }
        }
        else{
          final response = await NetworkUtil.internal().post('register', body: {
            'name':  _name,
            'email':  _email,
            'password': _password,
            'image': _password,
            'company_id': selectCompany,
          });
          final output = jsonDecode(response.body);
          if (output['code'] == 200) {
            setState(() {
              isLoading = false;
            });
            showDialogAlert(
                context: context, title: "Success", actionButtonTextStyle: const TextStyle(color: ColorRefer.kPrimaryColor), message: "Your account have been created successfully", actionButtonTitle: "OK", actionButtonOnPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          }
          else {
            setState(() {
              isLoading = false;
              print(output);
            });
            showDialogAlert(
                context: context, title: "Failed", actionButtonTextStyle: const TextStyle(color: ColorRefer.kPrimaryColor), message: output['message'], actionButtonTitle: "OK", actionButtonOnPressed: () {
              Navigator.pop(context);
            });
          }
        }
      }
    }catch(error){
      print('Error registering user: $error');
      setState(() {
        isLoading = false;
      });
    }

  }
  // [CompanyModel{id: 20, name: Ahad Ali, email: ahadali0500@gmail.com, logo: jquery_1720612854.png, password: ahadali0500, } , CompanyModel{id: 21, name: Desired Technology, email: desiredtechnology@gmail.com, logo: postman_1720673966.png, password: desiredtechnology, } ]

  @override
  Widget build(BuildContext context) {
    print(Constants.companyList!);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(
        color: ColorRefer.kPrimaryColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorRefer.kPrimaryColor,
          centerTitle: true,
          title: const Text(
            'Sign In',
            style:
            TextStyle(fontFamily: FontRefer.OpenSans),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, border: Border.all(color: borderColor)),
                            child: image != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(65),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            )
                                : SvgPicture.asset('assets/icons/person.svg')),
                        Positioned(
                            left: 100, top: 50, child: SvgPicture.asset('assets/icons/camera.svg', width: 30, height: 30,))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      InputField(
                        textInputType: TextInputType.name,
                        label: 'Name',
                        hintText: 'Name',
                        validator: (firstName) {
                          if (firstName!.isEmpty) return "Name is required";
                          if (firstName.length < 3)
                            return "Minimum three characters required";
                          return null;
                        },
                        onChanged: (value) => _name = value,
                      ),
                      const SizedBox(height: 15),
                      InputField(
                        textInputType: TextInputType.emailAddress,
                        label: 'Email',
                        hintText: 'user@mail.com',
                        validator: (String? emailValue) {
                          if (_email.isEmpty) return 'Email is required';
                          else {
                            String p =
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            RegExp regExp = new RegExp(p);
                            if (regExp.hasMatch((_email)))
                              return null;
                            else
                              return 'Email Syntax is not Correct';
                          }
                        },
                        onChanged: (value) => _email = value,
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        label: 'Select Company',
                        hintText: 'Choose item',
                        items: companyListModeMap.keys.toList(),
                        onChanged: (value) {
                          int? selectedId = companyListModeMap[value];
                          setState(() {
                            selectCompany = selectedId.toString();
                          });
                        },
                        onTap: (){},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an item';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      PasswordInputField(
                        label: 'Password',
                        hintText: '• • • • • • • • •',
                        textInputType: TextInputType.text,
                        obscureText: true,
                        validator: (String? password) {
                          if (password?.isEmpty ?? true)
                            return "Password is required!";
                          if ((password ?? "").length < 6)
                            return "Minimum 6 characters are required";
                          return null;
                        },
                        onChanged: (value) => _password = value,
                      ),
                      const SizedBox(height: 15),
                      PasswordInputField(
                        label: 'Confirm Password',
                        hintText: '• • • • • • • • •',
                        textInputType: TextInputType.text,
                        obscureText: true,
                        validator: (String? password) {
                          if (password?.isEmpty ?? true)
                            return "Password is required!";
                          if ((password ?? "").length < 6)
                            return "Minimum 6 characters are required";
                          if (password != _password)
                            return "Passwords do not match";
                          return null;
                        },
                        onChanged: (value) => _confirmPassword = value,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 25, right: 25),
                //   child: DropdownField(
                //     label: 'Select Company',
                //     hintText: 'Choose item',
                //     items: companyListModeMap.keys.toList(),
                //     onChanged: (value) {
                //       int? selectedId = companyListModeMap[value];
                //       setState(() {
                //         selectCompany = selectedId.toString();
                //       });
                //     },
                //     onTap: (){},
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please select an item';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 25),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _checkedValue,
                        activeColor: ColorRefer.kSecondary1Color,
                        side: BorderSide(
                          color: ColorRefer.kLabelColor,
                          width: 1.5,
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedValue = value!;
                          });
                        },
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontRefer.OpenSans,
                                    color: ColorRefer.kGreyColor),
                              ),
                              TextSpan(
                                  text: 'Terms of Services',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: FontRefer.OpenSans,
                                      color: ColorRefer.kSecondary1Color,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, TermsAndConditionScreen.ID);
                                    }),
                              const TextSpan(
                                text: ' & ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontRefer.OpenSans,
                                    color: ColorRefer.kGreyColor),
                              ),
                              TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: FontRefer.OpenSans,
                                      color: ColorRefer.kSecondary1Color,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, PrivacyAndPolicyScreen.ID);
                                    }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      ButtonWithIcon(
                          title: 'Sign Up',
                          buttonRadius: 25,
                          colour: _checkedValue
                              ? ColorRefer.kPrimaryColor
                              : ColorRefer.kPrimaryColor.withOpacity(0.5),
                          height: 50,
                          onPressed: _registerUser),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontRefer.OpenSans,
                              color: Colors.grey,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: FontRefer.OpenSans,
                                    color: ColorRefer.kSecondary1Color,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  showImageDialogBox() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: CameraGalleryBottomSheet(
                cameraClick: () => pickImage(ImageSource.camera),
                galleryClick: () => pickImage(ImageSource.gallery),
              ),
            ),
          );
        });
  }
}
