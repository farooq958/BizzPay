import 'dart:developer';

import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/broker_chat_details.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/chat_details.dart';
import 'Components/chat_tile.dart';
import 'Controllers/Repo/inboox_repo.dart';
import 'Controllers/inboxControllers.dart';
import 'Controllers/inboxmodel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.backButton});

  final bool? backButton;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  int chip = 0;

  List<ChatTileApiModel> businessChatData = [];
  List<ChatTileApiModel> brokers = [];

  @override
  void initState() {
    super.initState();

    print('Checking socket connection: ${InboxRepo.isConnected.value}');

    final userId = Data().user?.user?.id;
    if (userId != null) {
      final socket = InboxRepo.socket;

      // Emit event to get all business conversations
      socket?.emit("getAllBusinessConversations", {'userId': userId});

      socket?.on("allBusinessConversations", (data) {
        log('here is data$data');
        handleBusinessConversations(data);
      });

      socket?.onerror((e) {
        InboxControllers.businessChatLoading.value = 1;
        InboxControllers.businessChatLoading.notifyListeners();

        log("error here $e");
      });

      // Emit event to get all broker conversations
      socket?.emit("getAllBrokerConversations", {'userId': userId});
      socket?.on("allBrokerConversations", (data) {
        handleBrokerConversations(data);
      });
    } else {
      print('User ID is null, unable to fetch conversations.');
    }
  }

  void handleBusinessConversations(data) {
    InboxControllers.businessChatLoading.value = 1;
    InboxControllers.businessChatLoading.notifyListeners();

    log('Received business chat data: $data');

    List<ChatTileApiModel> chatsData = List<ChatTileApiModel>.from(
        data.map((x) => ChatTileApiModel.fromJson(x)));

    InboxControllers.businessChatTile.value = chatsData;
    InboxControllers.businessSearchChatTile.value = chatsData;
    InboxControllers.businessChatTile.notifyListeners();
    InboxControllers.businessSearchChatTile.notifyListeners();
  }

  void handleBrokerConversations(data) {
    log('Received broker chat data: $data');

    InboxControllers.businessChatLoading.value = 1;
    InboxControllers.businessChatLoading.notifyListeners();

    List<ChatTileApiModel> brokerChats = List<ChatTileApiModel>.from(
        data.map((x) => ChatTileApiModel.fromJson(x)));

    InboxControllers.brokerChatTile.value = brokerChats;
    InboxControllers.brokerSearchChatTile.value = brokerChats;
    InboxControllers.brokerChatTile.notifyListeners();
    InboxControllers.brokerSearchChatTile.notifyListeners();
  }

  @override
  void dispose() {
    // print("called");
    //  InboxRepo.socket?.disconnect();

    ///does not work on ios
    //InboxRepo.socket?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(businessChatData.toString());
    print(brokers.toString());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: AppText(
            'Chat',
            style: Styles.circularStdMedium(context, fontSize: 18.sp),
          ),
          //  leading: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.sp),
          child: Column(
            children: [
              // 25.y,
              // Align(
              //   alignment: Alignment.center,
              //   child: AppText('Chat',
              //       style: Styles.circularStdBold(context,
              //           fontSize: 18.sp, fontWeight: FontWeight.w500)),
              // ),
              CustomTextFieldWithOnTap(
                  filledColor: AppColors.searchFieldColor,
                  prefixIcon: SvgPicture.asset('assets/images/Search.svg'),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
                  borderRadius: 40,
                  controller: controller,
                  hintText: AppStrings.seerchChat,
                  onChanged: (value) {
                    _searchData(query: value);
                  },
                  textInputType: TextInputType.text),
              15.y,
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      chip = 0;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 8),
                      decoration: ShapeDecoration(
                        color: chip == 0
                            ? AppColors.borderColor
                            : AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(color: AppColors.borderColor),
                        ),
                      ),
                      child: Center(
                        child: AppText(
                          "Business chat",
                          style:
                              Styles.circularStdBold(context, fontSize: 13.sp),
                        ),
                      ),
                    ),
                  ),
                  18.x,
                  InkWell(
                    onTap: () {
                      chip = 1;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.50, vertical: 8),
                      decoration: ShapeDecoration(
                        color: chip == 1
                            ? AppColors.borderColor
                            : AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(color: AppColors.borderColor),
                        ),
                      ),
                      child: Center(
                        child: AppText(
                          "Experts",
                          style: Styles.circularStdBold(context,
                              fontSize: 13.sp, color: AppColors.greyTextColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              25.y,
              Expanded(
                  child: ValueListenableBuilder(
                builder: (context, chatState, ss) {
                  return InboxControllers.businessChatLoading.value == 1
                      ? chatState.isNotEmpty
                          ? ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 15.h,
                                );
                              },
                              shrinkWrap: true,
                              itemCount: chatState.length,
                              itemBuilder: (context, index) {
                                // print(chatState[0].toJson());

                                return InkWell(
                                  onTap: () {
                                    Navigate.to(
                                        context,
                                        chip == 0
                                            ? ChatDetailsScreen(
                                                chatDto: chatState[index])
                                            : BrokerChatDetailsScreen(
                                                chatDto: chatState[index],
                                              ));
                                  },
                                  child: ChatTile(
                                    // data: chip == 0 ? chatData[index] : brokers[index],
                                    tileData: chatState[index],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: AppText(
                              "No Conversation Found",
                              style: Styles.circularStdMedium(context),
                            ))
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                },
                valueListenable: chip == 0
                    ? InboxControllers.businessChatTile
                    : InboxControllers.brokerChatTile,
              ))
            ],
          ),
        ),
      ),
    );
  }

  _searchData({required String query}) {
    print(query);
    if (chip == 0) {
      if (query.isNotEmpty && query != "") {
        InboxControllers.businessChatTile.value = InboxControllers
            .businessSearchChatTile.value
            .where((element) =>
                element.username!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        InboxControllers.businessChatTile.notifyListeners();
      } else {
        print('in Else');

        InboxControllers.businessChatTile.value =
            InboxControllers.businessSearchChatTile.value;
        InboxControllers.businessChatTile.notifyListeners();
      }
    } else {
      if (query.isNotEmpty && query != "") {
        InboxControllers.brokerChatTile.value = InboxControllers
            .brokerSearchChatTile.value
            .where((element) =>
                element.username!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        InboxControllers.brokerChatTile.notifyListeners();
      } else {
        print('in Else');

        InboxControllers.brokerChatTile.value =
            InboxControllers.brokerSearchChatTile.value;
        InboxControllers.brokerChatTile.notifyListeners();
      }
    }
  }
}
