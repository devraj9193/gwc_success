import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:gwc_success_team/widgets/unfocus_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:sizer/sizer.dart';
import '../../controller/api_service.dart';
import '../../model/chat_repository/message_repo.dart';
import '../../model/chat_service/chat_service.dart';
import '../../model/doctor_list_model.dart';
import '../../model/error_model.dart';
import '../../model/message_model/get_chat_groupid_model.dart';
import '../../model/quick_blox_repository/message_wrapper.dart';
import '../../model/quick_blox_service/quick_blox_service.dart';
import '../../utils/constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../utils/gwc_api.dart';
import '../../widgets/widgets.dart';
import 'package:mime/mime.dart';
import '../customer_details_screens/meal_pdf.dart';

class MessageScreen extends StatefulWidget {
  final bool isGroupId;
  final String userName;
  final String profileImage;
  const MessageScreen(
      {Key? key,
      this.isGroupId = false,
      required this.userName,
      required this.profileImage})
      : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController commentController = TextEditingController();
  final searchController = TextEditingController();
  final SharedPreferences _pref = GwcApi.preferences!;

  ScrollController? _scrollController;

  QuickBloxService? _quickBloxService;

  bool isLoading = false;
  bool selectReceivers = false;

  List attachments = [];
  DoctorsList? doctorsList;

  String? _groupId;

  List doctorNameList = [];
  List doctorIdList = [];
  List searchResults = [];

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _quickBloxService = Provider.of<QuickBloxService>(context, listen: false);
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addObserver(this);
    }
    if (_pref != null) {
      if (_pref?.getString(GwcApi.groupId) != null) {
        _groupId = _pref!.getString(GwcApi.groupId);
        joinChatRoom(_pref!.getString(GwcApi.groupId)!);
      }
    }
    commentController.addListener(() {
      setState(() {});
    });
    _scrollController = ScrollController();
    // WidgetsBinding.instance?.addPostFrameCallback(-(_) => {
    //   _scrollController!.animateTo(
    //     0.0,
    //     duration: Duration(milliseconds: 200),
    //     curve: Curves.easeIn,
    //   )
    // });
    _scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.removeObserver(this);
    }
    commentController.dispose();
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  void _scrollListener() {
    double? maxScroll = _scrollController?.position.maxScrollExtent;
    double? currentScroll = _scrollController?.position.pixels;
    if (maxScroll == currentScroll && _quickBloxService!.hasMore == true) {
      _quickBloxService!.loadMessages(_groupId ?? '');
    }
  }

  Future<List<DoctorsTeam>?> fetchDoctorsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token")!;

    var response =
        await http.get(Uri.parse(GwcApi.doctorsListApiUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      doctorsList = doctorsListFromJson(response.body);
      List<DoctorsTeam>? arrData = doctorsList?.data;
      return arrData;
    } else {
      throw Exception();
    }
  }

  List<Message> messages = [
    Message(
        text: "Hi!\nI have some question about my prescription.",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 10),
        ),
        sendMe: false,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Hello, Adam!",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 10),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 6),
        ),
        sendMe: false,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "done.",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 6),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 3),
        ),
        sendMe: false,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 3),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 2),
        ),
        sendMe: false,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 2),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 0),
        ),
        sendMe: false,
        image:
            "assets/images/closeup-content-attractive-indian-business-lady.png"),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 0),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"),
  ].toList();

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: SafeArea(
          key: _scaffoldKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 2.w, right: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _quickBloxService!.disconnect();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: const Icon(
                          Icons.arrow_back,
                          color: gMainColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(widget.profileImage),
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: gGreyColor.withOpacity(0.5),
                                      offset: const Offset(2, 4),
                                      blurRadius: 5,
                                      spreadRadius: 0.1,
                                    ),
                                  ]),
                              width: 10.w,
                              height: 10.w,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
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
                                  fontSize: 8.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.local_phone,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
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
                        child: RawScrollbar(
                            isAlwaysShown: false,
                            thickness: 3,
                            controller: _scrollController,
                            radius: const Radius.circular(3),
                            thumbColor: gMainColor,
                            child: StreamBuilder(
                              stream: _quickBloxService!.stream.stream
                                  .asBroadcastStream(),
                              builder: (_, snapshot) {
                                print("snap.data: ${snapshot.data}");
                                if (snapshot.hasData) {
                                  return buildMessageList(
                                      snapshot.data as List<QBMessageWrapper>);
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )),
                      ),
                      _buildEnterMessageRow(),
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

  Widget _buildEnterMessageRow() {
    return SafeArea(
      child: Column(
        children: [
          _buildTypingIndicator(),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 3.w, top: 0.5.h),
                  // padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      // cursorColor: kPrimaryColor,
                      controller: commentController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        // hintText: "Say Something ...",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                          color: gMainColor,
                          fontSize: 10.sp,
                          fontFamily: "GothamBook",
                        ),
                        border: InputBorder.none,
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.sentiment_satisfied_alt_sharp,
                            color: gBlackColor,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            showAttachmentSheet(context);
                          },
                          child: const Icon(
                            Icons.attach_file_sharp,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      style: TextStyle(
                          fontFamily: "GothamBook",
                          color: gBlackColor,
                          fontSize: 10.sp),
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.none,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              commentController.text.toString().isEmpty
                  ? GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(right: 2.w),
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.mic_sharp,
                          color: gBlackColor,
                        ),
                      ),
                    )
                  : GestureDetector(
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
                        _quickBloxService!.sendMessage(_groupId!,
                            message: commentController.text);

                        commentController.clear();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 2.w),
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                          color: gPrimaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: gMainColor,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return StreamBuilder(
        stream: _quickBloxService!.typingStream.stream.asBroadcastStream(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            print("typing snap: ${snapshot.data}");
            return SizedBox(
              // color: Color(0xfff1f1f1),
              height: 35,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    Text(
                        (snapshot.data as List<String>).isEmpty
                            ? ''
                            : _makeTypingStatus(snapshot.data as List<String>),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff6c7a92),
                            fontStyle: FontStyle.italic))
                  ]),
            );
          }
          return const SizedBox();
        });
  }

  String _makeTypingStatus(List<String> usersName) {
    const int maxNameSize = 20;
    const int oneUser = 1;
    const int twoUsers = 2;

    String result = "";
    int namesCount = usersName.length;

    switch (namesCount) {
      case oneUser:
        String firstUser = usersName[0];
        if (firstUser.length <= maxNameSize) {
          result = firstUser + " is typing...";
        } else {
          result = firstUser.substring(0, maxNameSize - 1) + "… is typing...";
        }
        break;
      case twoUsers:
        String firstUser = usersName[0];
        String secondUser = usersName[1];
        if ((firstUser + secondUser).length > maxNameSize) {
          firstUser = _getModifiedUserName(firstUser);
          secondUser = _getModifiedUserName(secondUser);
        }
        result = firstUser + " and " + secondUser + " are typing...";
        break;
      default:
        String firstUser = usersName[0];
        String secondUser = usersName[1];
        String thirdUser = usersName[2];

        if ((firstUser + secondUser + thirdUser).length <= maxNameSize) {
          result = firstUser +
              ", " +
              secondUser +
              ", " +
              thirdUser +
              " are typing...";
        } else {
          firstUser = _getModifiedUserName(firstUser);
          secondUser = _getModifiedUserName(secondUser);
          result = firstUser +
              ", " +
              secondUser +
              " and " +
              (namesCount - 2).toString() +
              " more are typing...";
          break;
        }
    }
    return result;
  }

  String _getModifiedUserName(String name) {
    const int maxNameSize = 10;
    if (name.length >= maxNameSize) {
      name = name.substring(0, (maxNameSize) - 1) + "…";
    }
    return name;
  }

  buildMessageList(List<QBMessageWrapper> messageList) {
    return GroupedListView<QBMessageWrapper, DateTime>(
      elements: messageList,
      order: GroupedListOrder.DESC,
      reverse: true,
      floatingHeader: true,
      useStickyGroupSeparators: true,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      groupBy: (QBMessageWrapper message) =>
          DateTime(message.date.year, message.date.month, message.date.day),
      // padding: EdgeInsets.symmetric(horizontal: 0.w),
      groupHeaderBuilder: (QBMessageWrapper message) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, bottom: 7),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: const BoxDecoration(
              color: Color(0xffd9e3f7),
              borderRadius: BorderRadius.all(
                Radius.circular(11),
              ),
            ),
            child: Text(
              _buildHeaderDate(message.qbMessage.dateSent),
              style: TextStyle(
                fontFamily: "GothamBook",
                color: gBlackColor,
                fontSize: 8.sp,
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context, QBMessageWrapper message) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //     child: message.isIncoming
          //         ? _generateAvatarFromName(message.senderName)
          //         : null),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: message.isIncoming
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  IntrinsicWidth(
                    child: (message.qbMessage.attachments == null ||
                            message.qbMessage.attachments!.isEmpty)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // overflow: Overflow.visible,
                            // clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 2.w, right: 2.w, bottom: 0.5.h),
                                constraints: BoxConstraints(maxWidth: 70.w),
                                margin: message.isIncoming
                                    ? EdgeInsets.only(
                                        top: 0.5.h, bottom: 0.5.h, left: 5)
                                    : EdgeInsets.only(
                                        top: 0.5.h, bottom: 0.5.h, right: 5),
                                // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  color: message.isIncoming
                                      ? gWhiteColor
                                      : gChatMeColor,
                                  boxShadow: message.isIncoming
                                      ? [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            offset: const Offset(2, 4),
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            offset: const Offset(2, 4),
                                            blurRadius: 10,
                                          ),
                                        ],
                                  borderRadius: BorderRadius.circular(7),
                                  // BorderRadius.only(
                                  //     topLeft: const Radius.circular(18),
                                  //     topRight: const Radius.circular(18),
                                  //     bottomLeft: message.isIncoming
                                  //         ? const Radius.circular(0)
                                  //         : const Radius.circular(18),
                                  //     bottomRight: message.isIncoming
                                  //         ? const Radius.circular(18)
                                  //         : const Radius.circular(0),),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        message.qbMessage.body ?? '',
                                        style: TextStyle(
                                            fontFamily: "GothamBook",
                                            height: 1.5,
                                            color: gBlackColor,
                                            fontSize: 10.sp),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 0.5.h),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children:
                                              _buildNameTimeHeader(message),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : FutureBuilder(
                            future: _quickBloxService!.getQbAttachmentUrl(
                                message.qbMessage.attachments!.first!.id!),
                            builder: (_, imgUrl) {
                              print('imgUrl.hasError: ${imgUrl.hasError}');
                              if (imgUrl.hasData) {
                                QBFile? _file;
                                print(
                                    "imgUrl.runtimeType: ${imgUrl.data.runtimeType}");
                                _file = (imgUrl.data as Map)['file'];
                                // print('_file!.name: ${_file!.name}');
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (message.qbMessage.attachments!
                                                .first!.type ==
                                            'application/pdf') {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                opaque: false, // set to false
                                                pageBuilder: (_, __, ___) {
                                                  return MealPdf(
                                                    pdfLink: (imgUrl.data
                                                        as Map)['url'],
                                                  );
                                                },
                                              ));
                                        } else {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                opaque: false, // set to false
                                                pageBuilder: (_, __, ___) {
                                                  return showImageFullScreen(
                                                      (imgUrl.data
                                                          as Map)['url']);
                                                },
                                              ));
                                        }
                                      },
                                      child: Container(
                                        height: message.qbMessage.attachments!
                                                    .first!.type ==
                                                'application/pdf'
                                            ? null
                                            : 200,
                                        width: message.qbMessage.attachments!
                                                    .first!.type ==
                                                'application/pdf'
                                            ? null
                                            : 200,
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 13,
                                            bottom: 13),
                                        constraints:
                                            BoxConstraints(maxWidth: 70.w),
                                        margin: message.isIncoming
                                            ? EdgeInsets.only(
                                                top: 1.h, bottom: 1.h, left: 5)
                                            : EdgeInsets.only(
                                                top: 1.h,
                                                bottom: 1.h,
                                                right: 5),
                                        // padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                                        decoration: (message.qbMessage
                                                    .attachments!.first!.type ==
                                                'application/pdf')
                                            ? BoxDecoration(
                                                color: message.isIncoming
                                                    ? gGreyColor
                                                        .withOpacity(0.2)
                                                    : gSecondaryColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(18),
                                                    topRight:
                                                        Radius.circular(18),
                                                    bottomLeft: message.isIncoming
                                                        ? Radius.circular(0)
                                                        : Radius.circular(18),
                                                    bottomRight: message.isIncoming
                                                        ? Radius.circular(18)
                                                        : Radius.circular(0)))
                                            : BoxDecoration(
                                                image: DecorationImage(
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.fill,
                                                    image: CachedNetworkImageProvider((imgUrl.data as Map)['url'])),
                                                boxShadow: [BoxShadow(color: gGreyColor.withOpacity(0.5), blurRadius: 0.2)],
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: message.isIncoming ? Radius.circular(0) : Radius.circular(18), bottomRight: message.isIncoming ? Radius.circular(18) : Radius.circular(0))),
                                        child: (message.qbMessage.attachments!
                                                    .first!.type ==
                                                'application/pdf')
                                            ? (_file != null)
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _file.name ?? '',
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              fontFamily:
                                                                  'GothamMedium',
                                                              color:
                                                                  gWhiteColor),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.download,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () async {
                                                          if (_file != null) {
                                                            await _quickBloxService!
                                                                .downloadFile(
                                                                    (imgUrl.data
                                                                            as Map)[
                                                                        'url'],
                                                                    _file.name!)
                                                                .then((value) {
                                                              File file =
                                                                  value as File;
                                                              showSnackbar(
                                                                  context,
                                                                  "file saved to ${file.path}");
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              showSnackbar(
                                                                  context,
                                                                  "file download error");
                                                            });
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  )
                                                : null
                                            : null,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: _buildNameTimeHeader(message),
                                    )
                                  ],
                                );
                              } else {
                                print("imgUrl.error: ${imgUrl.error}");
                                return SizedBox.shrink(
                                    child: Text('Not found'));
                              }
                              return SizedBox.shrink();
                            }),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: PopupMenuButton(
              offset: const Offset(0, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: GestureDetector(
                    onTap: () {
                      print("${message.qbMessage.body}");
                      openDialog("${message.qbMessage.body}");
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.shortcut_sharp,
                          color: gBlackColor,
                          size: 2.h,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Forward",
                          style: TextStyle(
                              fontFamily: "GothamBook",
                              color: gBlackColor,
                              fontSize: 9.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              child: Icon(
                Icons.more_vert_sharp,
                size: 2.h,
                color: gGreyColor.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
      controller: _scrollController,
    );
  }

  showImageFullScreen(String url) {
    print(url);
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(
        url,
      ),
    );
  }

  List<Widget> _buildNameTimeHeader(message) {
    return <Widget>[
      // const Padding(padding: EdgeInsets.only(left: 16)),
      // _buildSenderName(message),
      // const Padding(padding: EdgeInsets.only(left: 7)),
      // const Expanded(child: SizedBox.shrink()),
      //  const Padding(padding: EdgeInsets.only(left: 3)),
      _buildDateSent(message),
      Padding(padding: EdgeInsets.only(left: 1.w)),
      message.isIncoming
          ? const SizedBox.shrink()
          : _buildMessageStatus(message),
    ];
  }

  Widget _buildMessageStatus(message) {
    var deliveredIds = message.qbMessage.deliveredIds;
    var readIds = message.qbMessage.readIds;
    // if (_dialogType == QBChatDialogTypes.PUBLIC_CHAT) {
    //   return SizedBox.shrink();
    // }
    if (readIds != null && readIds.length > 1) {
      return const Icon(
        Icons.done_all,
        color: Colors.blue,
        size: 14,
      );
    } else if (deliveredIds != null && deliveredIds.length > 1) {
      return const Icon(Icons.done_all, color: gGreyColor, size: 14);
    } else {
      return const Icon(Icons.done, color: gGreyColor, size: 14);
    }
  }

  Widget _buildSenderName(message) {
    return Text(message.senderName ?? "No name",
        maxLines: 1,
        style: TextStyle(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black54));
  }

  Widget _buildDateSent(message) {
    // print("DateTime:${message.qbMessage.dateSent!}");
    return Text(
      _buildTime(message.qbMessage.dateSent!),
      maxLines: 1,
      style: TextStyle(
        fontSize: 7.sp,
        color: gTextColor,
        fontFamily: "GothamBook",
      ),
    );
  }

  String _buildTime(int timeStamp) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    String amPm = 'AM';
    if (dateTime.hour >= 12) {
      amPm = 'PM';
    }

    String hour = dateTime.hour.toString();
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    }

    String minute = dateTime.minute.toString();
    if (dateTime.minute < 10) {
      minute = '0${dateTime.minute}';
    }
    return '$hour:$minute  $amPm';
  }

  Widget _generateAvatarFromName(String? name) {
    name ??= "No name";
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: gMainColor.withOpacity(0.18),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
              color: gPrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'GothamMedium'),
        ),
      ),
    );
  }

  showAttachmentSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 4),
                      child: const Text(
                        'Choose File Source',
                        style: TextStyle(
                          color: gPrimaryColor,
                          fontFamily: 'GothamMedium',
                        ),
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gGreyColor,
                          width: 3.0,
                        ),
                      )),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText(Icons.insert_drive_file, 'Document', () {
                          pickFromFile();
                          Navigator.pop(context);
                        }),
                        iconWithText(Icons.camera_enhance_outlined, 'Camera',
                            () {
                          getImageFromCamera();
                          Navigator.pop(context);
                        }),
                        iconWithText(Icons.image, 'Gallery', () {
                          getImageFromCamera(fromCamera: false);
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              )
            ],
          );
        });
  }

  String _buildHeaderDate(int? timeStamp) {
    String completedDate = "";
    DateFormat dayFormat = DateFormat("d MMMM");
    DateFormat lastYearFormat = DateFormat("dd.MM.yy");

    DateTime now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = DateTime(now.year, now.month, now.day - 1);

    timeStamp ??= 0;
    DateTime messageTime =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    DateTime messageDate =
        DateTime(messageTime.year, messageTime.month, messageTime.day);

    if (today == messageDate) {
      completedDate = "Today";
    } else if (yesterday == messageDate) {
      completedDate = "Yesterday";
    } else if (now.year == messageTime.year) {
      completedDate = dayFormat.format(messageTime);
    } else {
      completedDate = lastYearFormat.format(messageTime);
    }

    return completedDate;
  }

  iconWithText(IconData assetName, String optionName, VoidCallback onPress) {
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: gPrimaryColor),
              child: Center(
                child: Icon(
                  assetName,
                  color: gMainColor,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              optionName,
              style: TextStyle(
                color: gBlackColor,
                fontSize: 9.sp,
                fontFamily: "GothamBook",
              ),
            )
          ],
        ),
      ),
    );
  }

  // void unsubscribeNewMessage() {
  //   if (_newMessageSubscription != null) {
  //     _newMessageSubscription!.cancel();
  //     _newMessageSubscription = null;
  //     AppConfig().showSnackbar(
  //         context, "Unsubscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
  //   }
  // }
  //
  // void unsubscribeDeliveredMessage() async {
  //   if (_deliveredMessageSubscription != null) {
  //     _deliveredMessageSubscription!.cancel();
  //     _deliveredMessageSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.MESSAGE_DELIVERED);
  //   }
  // }
  //
  // void unsubscribeReadMessage() async {
  //   if (_readMessageSubscription != null) {
  //     _readMessageSubscription!.cancel();
  //     _readMessageSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.MESSAGE_READ);
  //   }
  // }
  //
  // void unsubscribeUserTyping() async {
  //   if (_userTypingSubscription != null) {
  //     _userTypingSubscription!.cancel();
  //     _userTypingSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.USER_IS_TYPING);
  //   }
  // }
  //
  // void unsubscribeUserStopTyping() async {
  //   if (_userStopTypingSubscription != null) {
  //     _userStopTypingSubscription!.cancel();
  //     _userStopTypingSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.USER_STOPPED_TYPING);
  //   }
  // }
  //
  // void unsubscribeConnected() {
  //   if (_connectedSubscription != null) {
  //     _connectedSubscription!.cancel();
  //     _connectedSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.CONNECTED);
  //   }
  // }
  //
  // void unsubscribeConnectionClosed() {
  //   if (_connectionClosedSubscription != null) {
  //     _connectionClosedSubscription!.cancel();
  //     _connectionClosedSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.CONNECTION_CLOSED);
  //   }
  // }
  //
  // void unsubscribeReconnectionFailed() {
  //   if (_reconnectionFailedSubscription != null) {
  //     _reconnectionFailedSubscription!.cancel();
  //     _reconnectionFailedSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.RECONNECTION_FAILED);
  //   }
  // }
  //
  // void unsubscribeReconnectionSuccess() {
  //   if (_reconnectionSuccessSubscription != null) {
  //     _reconnectionSuccessSubscription!.cancel();
  //     _reconnectionSuccessSubscription = null;
  //     AppConfig().showSnackbar(context,
  //         "Unsubscribed: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
  //   }
  // }

  joinChatRoom(String groupId) async {
    await Provider.of<QuickBloxService>(context, listen: false)
        .joinDialog(groupId);

    Future.delayed(const Duration(seconds: 15)).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  File? _image;

  List<PlatformFile> files = [];

  Future getImageFromCamera({bool fromCamera = true}) async {
    var image = await ImagePicker.platform.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
    sendQbAttachment(_image!.path, 'photo');
    print("captured image: $_image");
  }

  void pickFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.any,
      // allowedExtensions: ['pdf', 'jpg', 'png'],
      allowMultiple: false,
    );
    if (result == null) return;

    if (result.files.first.extension!.contains("pdf") ||
        result.files.first.extension!.contains("png") ||
        result.files.first.extension!.contains("jpg")) {
      if (getFileSize(File(result.paths.first!)) <= 10) {
        print("fileSize: ${getFileSize(File(result.paths.first!))}Mb");
        files.add(result.files.first);
      } else {
        showSnackbar(context, "File size must be < 10Mb", isError: true);
      }
    } else {
      showSnackbar(context, "Please select png/jpg/Pdf files", isError: true);
    }
    sendQbAttachment(files.first.path!, 'doc');
    setState(() {});
  }

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  sendQbAttachment(String url, String fileType) async {
    try {
      QBFile? file;
      file = await QB.content.upload(url);
      if (file != null) {
        int id = file.id!;
        String contentType = file.contentType!;

        QBAttachment attachment = QBAttachment();
        attachment.id = id.toString();
        attachment.contentType = contentType;

        //Required parameter
        attachment.type = lookupMimeType(url);
        attachment.contentType = lookupMimeType(url);

        List<QBAttachment> attachmentsList = [];
        attachmentsList.add(attachment);

        QBMessage message = QBMessage();
        message.attachments = attachmentsList;

        _quickBloxService!.sendMessage(_groupId!, attachments: attachmentsList);

        // Send a message logic
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future openDialog(String message) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            width: double.maxFinite,
            height: double.maxFinite,
            child: FutureBuilder(
              future: fetchDoctorsList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("No List"));
                } else if (snapshot.hasData) {
                  var data = snapshot.data;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Forward Message',
                                style: TextStyle(
                                    fontFamily: "GothamMedium",
                                    color: gBlackColor,
                                    fontSize: 10.sp),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear,
                              color: gBlackColor,
                              size: 2.h,
                            ),
                          ),
                          SizedBox(width: 2.w)
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 20.w),
                        height: 1,
                        color: gGreyColor.withOpacity(0.5),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: gTapColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.reply_outlined,
                                size: 2.h, color: gBlackColor),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                message,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "GothamBook",
                                  height: 1.3,
                                  fontSize: 8.sp,
                                  color: gBlackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 5.h,
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(color: gBlackColor),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.search,
                              color: gBlackColor,
                              size: 2.h,
                            ),
                            hintText: "Please Enter Name",
                            hintStyle: TextStyle(
                              fontFamily: "PoppinsRegular",
                              color: gGreyColor,
                              fontSize: 10.sp,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: "PoppinsRegular",
                            color: gBlackColor,
                            fontSize: 11.sp,
                          ),
                          onChanged: (value) {
                            onSearchTextChanged(value, setState);
                          },
                        ),
                      ),
                      SizedBox(height: 2.h),
                      searchController.text.isEmpty
                          ? Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ListView.builder(
                                  itemCount: data.length,
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 2.h,
                                              backgroundImage: NetworkImage(
                                                data[index].profile.toString(),
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[index].name,
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "GothamMedium",
                                                      fontSize: 9.sp,
                                                      color: gBlackColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  Text(
                                                    data[index].email,
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: "GothamBook",
                                                      fontSize: 9.sp,
                                                      color: gBlackColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                getForwardChatGroupId(data[index].id.toString(),message);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.5.h,
                                                    horizontal: 2.w),
                                                decoration: BoxDecoration(
                                                  color: gPdfColor,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Send',
                                                    style: TextStyle(
                                                      fontFamily: "GothamBook",
                                                      color: gBlackColor,
                                                      fontSize: 7.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 1.5.h),
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: ListView.builder(
                                    itemCount: searchResults.length,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 2.h,
                                                backgroundImage: NetworkImage(
                                                  data[index]
                                                      .profile
                                                      .toString(),
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      searchResults[index].name,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "GothamMedium",
                                                        fontSize: 9.sp,
                                                        color: gBlackColor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 0.5.h),
                                                    Text(
                                                      searchResults[index]
                                                          .email,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "GothamBook",
                                                        fontSize: 9.sp,
                                                        color: gBlackColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  getForwardChatGroupId(searchResults[index].id.toString(),message);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0.5.h,
                                                      horizontal: 2.w),
                                                  decoration: BoxDecoration(
                                                    color: gPdfColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Send',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "GothamBook",
                                                        color: gBlackColor,
                                                        fontSize: 7.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 1.5.h),
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                      SizedBox(
                        height: 6.h,
                      ),
                      (doctorIdList.isNotEmpty)
                          ? CommonButton.submitButton(() {
                              Navigator.pop(context, doctorNameList);
                            }, "Submit")
                          : Container(),
                    ],
                  );
                }
                return buildCircularIndicator();
              },
            ),
          );
        }),
      ),
    );
  }

  onSearchTextChanged(String text, StateSetter setState) async {
    searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    doctorsList?.data?.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text.trim().toLowerCase()) ||
          userDetail.email!.toLowerCase().contains(text.trim().toLowerCase())) {
        searchResults.add(userDetail);
      }
    });
    setState(() {});
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  getForwardChatGroupId(String userId,String message) async {
    print(_pref.getInt(GwcApi.getQBSession));
    print(_pref.getBool(GwcApi.isQBLogin));

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var chatUserName = preferences.getString("chatUserName")!;
    print("UserName: $chatUserName");

    print(_pref.getInt(GwcApi.getQBSession) == null ||
        _pref.getBool(GwcApi.isQBLogin) == null ||
        _pref.getBool(GwcApi.isQBLogin) == false);
    final _qbService = Provider.of<QuickBloxService>(context, listen: false);
    print(await _qbService.getSession());
    if (_pref.getInt(GwcApi.getQBSession) == null ||
        await _qbService.getSession() == true ||
        _pref.getBool(GwcApi.isQBLogin) == null ||
        _pref.getBool(GwcApi.isQBLogin) == false) {
      _qbService.login(chatUserName);
    } else {
      if (await _qbService.isConnected() == false) {
        _qbService.connect(_pref.getInt(GwcApi.qbCurrentUserId)!);
      }
    }
    final res = await ChatService(repository: chatRepository)
        .getGwcTeamChatGroupIdService(userId);

    if (res.runtimeType == GetChatGroupIdModel) {
      GetChatGroupIdModel model = res as GetChatGroupIdModel;
      // QuickBloxRepository().init(AppConfig.QB_APP_ID, AppConfig.QB_AUTH_KEY, AppConfig.QB_AUTH_SECRET, AppConfig.QB_ACCOUNT_KEY);
      _pref.setString(GwcApi.groupId, model.group ?? '');
      print('model.group: ${model.group}');
      QB.chat.sendMessage("${model.group}", body: message, saveToHistory: true, markable: true);
    } else {
      ErrorModel model = res as ErrorModel;
      showSnackbar(context, model.message.toString(), isError: true);
    }
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
