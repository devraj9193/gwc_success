import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gwc_success_team/screens/bottom_bar/dashboard_screen.dart';
import 'package:gwc_success_team/widgets/unfocus_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../controller/api_service.dart';
import '../../model/success_user_model/success_member_profile_repository.dart';
import '../../model/success_user_model/success_member_service.dart';
import '../../model/user_profile_model.dart';
import '../../utils/constants.dart';
import '../../utils/gwc_api.dart';
import '../../widgets/common_screen_widgets.dart';
import '../../widgets/widgets.dart';
import '../../widgets/will_pop_widget.dart';

class SuccessLogin extends StatefulWidget {
  const SuccessLogin({Key? key}) : super(key: key);

  @override
  State<SuccessLogin> createState() => _SuccessLoginState();
}

class _SuccessLoginState extends State<SuccessLogin> {
  final formKey = GlobalKey<FormState>();
  final SharedPreferences _pref = GwcApi.preferences!;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool passwordVisibility;
  bool isLoading = false;
  String? deviceToken = "";

  @override
  void initState() {
    super.initState();
    doctorDeviceToken();
    passwordVisibility = false;
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  void doctorDeviceToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    deviceToken = preferences.getString("device_token");
    setState(() {});
    print("deviceToken111: $deviceToken");
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: UnfocusWidget(
        child: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: [
                const Image(
                  image: AssetImage(
                    "assets/images/environment-green-watercolor-background-with-leaf-border-illustration (1).png",
                  ),
                  fit: BoxFit.fill,
                ),
                Column(
                  children: [
                    SizedBox(height: 12.h),
                    Center(
                      child: Image(
                        image: const AssetImage(
                            "assets/images/Gut wellness logo.png"),
                        height: 12.h,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "WELCOME TO",
                          style: LoginScreen().welcomeText(),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Success Team",
                          style: LoginScreen().doctorAppText(),
                        ),
                      ),
                    ),
                    buildForm(),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: RichText(
                    //     text: TextSpan(
                    //         text: 'By signing up, you are agree with our',
                    //         style: TextStyle(
                    //             fontFamily: "GothamBold",
                    //             color: gMainColor,
                    //             fontSize: 8.sp),
                    //         children: [
                    //           TextSpan(
                    //             text: 'Terms & Conditions',
                    //             style: TextStyle(
                    //               fontFamily: "GothamBold",
                    //               color: gMainColor,
                    //               fontSize: 8.sp,
                    //               decoration: TextDecoration.underline,
                    //             ),
                    //             recognizer: TapGestureRecognizer()
                    //               ..onTap = () {
                    //                 // print('Tap Here onTap');
                    //               },
                    //           )
                    //         ]),
                    //   ),
                    // ),
                    // SizedBox(height: 3.h),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  buildForm() {
    return Form(
      key: formKey,
      child: Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10.w),
                //   child: Text(
                //     "Lorem ipsum is simply dummy text of the printing and typesetting industry",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         height: 1.5,
                //         fontFamily: "GothamBold",
                //         color: gSecondaryColor,
                //         fontSize: 10.sp),
                //   ),
                // ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  cursorColor: newBlackColor,
                  textAlignVertical: TextAlignVertical.center,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email ID';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter your valid Email ID';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail_outline_sharp,
                      color: newBlackColor,
                      size: 15.sp,
                    ),
                    hintText: "Email",
                    hintStyle: LoginScreen().hintTextField(),
                    suffixIcon: (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.value.text))
                        ? emailController.text.isEmpty
                            ? Container(
                                width: 0,
                              )
                            : InkWell(
                                onTap: () {
                                  emailController.clear();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: newBlackColor,
                                  size: 15,
                                ),
                              )
                        : Icon(
                            Icons.check_circle,
                            color: gPrimaryColor,
                            size: 15.sp,
                          ),
                  ),
                  style: LoginScreen().mainTextField(),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 5.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: newBlackColor,
                  controller: passwordController,
                  obscureText: !passwordVisibility,
                  textAlignVertical: TextAlignVertical.center,
                  style: LoginScreen().mainTextField(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Password';
                    }
                    if (!RegExp('[a-zA-Z]')
                        // RegExp(
                        //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                        .hasMatch(value)) {
                      return 'Password may contains alpha numeric';
                    }
                    if (value.length < 6 || value.length > 20) {
                      return 'Password must me 6 to 20 characters';
                    }
                    if (!RegExp('[a-zA-Z]')
                        // RegExp(
                        //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                        .hasMatch(value)) {
                      return 'Password must contains \n '
                          '1-symbol 1-alphabet 1-number';
                    }
                    return null;
                  },
                  onFieldSubmitted: (val) {
                    formKey.currentState!.validate();
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline_sharp,
                      color: newBlackColor,
                      size: 15.sp,
                    ),
                    hintText: "Password",
                    hintStyle: LoginScreen().hintTextField(),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passwordVisibility = !passwordVisibility;
                        });
                      },
                      child: Icon(
                        passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: passwordVisibility
                            ? gPrimaryColor
                            : mediumTextColor,
                        size: 15.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (ct) => const ForgotPassword()));
                //     },
                //     child: Text(
                //       'Forgot Password?',
                //       style: TextStyle(
                //         fontFamily: "GothamBook",
                //         color: gMainColor,
                //         fontSize: 8.sp,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: (isLoading)
                      ? null
                      : () {
                          buildLogin();
                        },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: gSecondaryColor,
                      // (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      //             .hasMatch(emailController.value.text) ||
                      //         !RegExp('[a-zA-Z]')
                      //             //  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                      //             .hasMatch(passwordController.value.text))
                      //     ? gMainColor
                      //     : gPrimaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: (isLoading)
                        ? buildThreeBounceIndicator(color: whiteTextColor)
                        : Center(
                            child: Text(
                              'LOGIN',
                              style: LoginScreen().buttonText(whiteTextColor),
                              // TextStyle(
                              //   fontFamily: "GothamMedium",
                              //   color: whiteTextColor
                              //   (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //               .hasMatch(
                              //                   emailController.value.text) ||
                              //           !RegExp('[a-zA-Z]')
                              //               //  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                              //               .hasMatch(
                              //                   passwordController.value.text))
                              //       ? gPrimaryColor
                              //       : gMainColor,
                              //   fontSize: 9.sp,
                              // ),
                            ),
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

  void buildLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await FirebaseMessaging.instance.getToken().then((value) {
        setState(() {
          deviceToken = value!;
          print("Device Token is Login: $deviceToken");
        });
      });
      try {
        Map<String, dynamic> dataBody = {
          "email": emailController.text.toString(),
          "password": passwordController.text.toString(),
          "device_token": deviceToken,
        };
        print("dataBody : $dataBody");
        var response =
            await http.post(Uri.parse(GwcApi.loginApiUrl), body: dataBody);
        print("login: ${response.body}");
        if (response.statusCode == 200) {
          setState(() {
            isLoading = true;
          });
          Map<String, dynamic> responseData = jsonDecode(response.body);
          saveData(
            responseData["access_token"],
            responseData["user"]["login_username"].toString(),
            responseData["user"]["chat_id"].toString(),
            responseData["user"]["kaleyra_user_id"].toString(),
          );
          print("Token : ${responseData["access_token"]}");
          if (responseData['status'] == 200) {
            setState(() {
              isLoading = true;
            });
            // final qbService =
            //     Provider.of<QuickBloxService>(context, listen: false);
            // qbService.login(responseData["user"]["login_username"].toString());

            buildSnackBar("Login", "Successful");
            // qbService.kaleyraLogin(
            //     responseData["user"]["kaleyra_user_id"].toString());
            storeUserProfile(responseData["access_token"]);
            Get.to(() => const DashboardScreen());
          } else if (responseData['status'] == 401) {
            setState(() {
              isLoading = false;
            });
            buildSnackBar("Login Failed", responseData['message']);
          }
        } else {
          setState(() {
            isLoading = false;
          });
          buildSnackBar("Login Failed", "API Problem");
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e);
        buildSnackBar("Login Failed", "$e");
        throw Exception(e);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      buildSnackBar("Invalid Form", "Please complete the form Properly");
    }
  }

  final SuccessMemberProfileRepository userRepository =
      SuccessMemberProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void storeUserProfile(String accessToken) async {
    final profile =
        await SuccessMemberProfileService(repository: userRepository)
            .getSuccessMemberProfileService(accessToken);
    if (profile.runtimeType == GetUserModel) {
      GetUserModel model1 = profile as GetUserModel;
      print("model1.datqbUserIda!.: ${model1.data!.address}");

      _pref.setString(GwcApi.successMemberName, model1.data?.name ?? "");
      _pref.setString(GwcApi.successMemberProfile, model1.data?.profile ?? "");
      _pref.setString(GwcApi.successMemberAddress, model1.data?.phone ?? "");

      print("Success Name : ${_pref.getString(GwcApi.successMemberName)}");
      print(
          "Success Profile : ${_pref.getString(GwcApi.successMemberProfile)}");
      print(
          "Success Address : ${_pref.getString(GwcApi.successMemberAddress)}");
    }
  }

  // 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

  saveData(String token, String chatUserName, String chatUserId,
      String kaleyraUserId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("chatUserName", chatUserName);
    preferences.setString("chatUserId", chatUserId);
    preferences.setString("kaleyraUserId", kaleyraUserId);

    print("QB User Name : ${preferences.getString("chatUserName")}");
    print("QB Chat Id : ${preferences.getString("chatUserId")}");
    print("Kaleyra Chat Id : ${preferences.getString("kaleyraUserId")}");
  }
}
