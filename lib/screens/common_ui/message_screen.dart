import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:gwc_success_team/widgets/unfocus_widget.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:sizer/sizer.dart';
import '../../utils/constants.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}


class _MessageScreenState extends State<MessageScreen> {
  final formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    commentController.addListener(() {
      setState(() {});
    });
  }

  List<Message> messages = [
    Message(
        text: "Hi!\nI have some question about my prescription.",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 10),
        ),
        sendMe: false,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Hello, Adam!",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 10),
        ),
        sendMe: true,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 6),
        ),
        sendMe: false,
        image: "assets/images/cheerful.png"),
    Message(
        text: "done.",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 6),
        ),
        sendMe: true,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 3),
        ),
        sendMe: false,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 3),
        ),
        sendMe: true,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 2),
        ),
        sendMe: false,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 2),
        ),
        sendMe: true,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 0),
        ),
        sendMe: false,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 0),
        ),
        sendMe: true,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
  ].toList();

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(Icons.arrow_back,
                          color: gMainColor,
                        ),
                      )
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/cheerful.png")
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: gGreyColor,
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  spreadRadius: 0.1,
                                ),
                              ]
                            ),
                            width: 9.w,
                            height: 9.w,
                            // backgroundImage: AssetImage("assets/images/cheerful.png"),
                          ),
                          SizedBox(width: 2.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loreum Ipsum dadids',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontFamily: 'GothamMedium',
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Text(
                                'Bangalore, India',
                                style: TextStyle(
                                  color: kTextColor,
                                  fontFamily: 'GothamBook',
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: gWhiteColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.local_phone,
                          color: gPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: buildMessageList(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F4F4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Form(
                                key: formKey,
                                child: Center(
                                  child: TextFormField(
                                    cursorColor: kPrimaryColor,
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: "Say Something ...",
                                      hintStyle: TextStyle(
                                        color: gMainColor,
                                        fontSize: 9.sp,
                                        fontFamily: "GothamBook",
                                      ),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mood),
                                      suffixIcon: commentController.text
                                              .toString()
                                              .isEmpty
                                          ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.attach_file,
                                              color: gPrimaryColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: const Icon(
                                              CupertinoIcons.camera_fill,
                                              color: gPrimaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(
                                              width: 0,
                                            ),
                                    ),
                                    style: TextStyle(
                                        fontFamily: "GothamMedium",
                                        color: gTextColor,
                                        fontSize: 9.sp),
                                    textInputAction: TextInputAction.next,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          commentController.text.toString().isNotEmpty
                              ? SizedBox(
                                  width: 2.w,
                                )
                              : Container(width: 0),
                          commentController.text.toString().isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : InkWell(
                                  onTap: () {
                                    final message = Message(
                                        text: commentController.text.toString(),
                                        date: DateTime.now(),
                                        sendMe: true,
                                        image:
                                            "assets/images/closeup-content-attractive-indian-business-lady.png");
                                    setState(() {
                                      messages.add(message);
                                    });
                                    commentController.clear();
                                  },
                                  child: const Icon(
                                    Icons.send,
                                    color: kPrimaryColor,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildMessageList() {
    return GroupedListView<Message, DateTime>(
      elements: messages,
      groupBy: (message) =>
          DateTime(message.date.year, message.date.month, message.date.day),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      groupHeaderBuilder: (Message message) => Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          child: Text(
            DateFormat.yMMMd().format(message.date),
            style: TextStyle(
                fontFamily: "GothamBook",
                height: 1.5,
                color: gGreyColor.withOpacity(0.5),
                fontSize: 9.sp),
          ),
        ),
      ),
      itemBuilder: (context, Message message) => Align(
        alignment:
            message.sendMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              margin: message.sendMe
                  ? EdgeInsets.only(top: 1.h, bottom: 1.h, left: 10.w)
                  : EdgeInsets.only(top: 1.h, bottom: 1.h, right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                  color: message.sendMe
                      ? gChatMeColor
                      : gSecondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text.toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: "GothamBook",
                        height: 1.5,
                        color: message.sendMe ? gTextColor : gWhiteColor,
                        fontSize: 10.sp),
                  ),
                  Positioned(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('10:49 AM',
                            style: TextStyle(
                                fontSize: 8.sp
                            ),
                          ),
                          Visibility(
                              visible: message.sendMe,
                              child: Icon(Icons.done_all,
                                size: 10.sp,
                              )
                          )
                        ],
                      ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final DateTime date;
  final bool sendMe;
  final String image;

  Message(
      {required this.text,
      required this.date,
      required this.sendMe,
      required this.image});
}
