import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _controller = ScrollController();
  final promptController = TextEditingController();

  bool shouldScroll = false;

  bool isDisabled = false;
  List<Message> chat = [
    Message(
        isUser: false, text: "Hello Nanna and Shannon, How can I help you?"),
  ];

  _send(String query) async {
    promptController.clear();
    setState(() {
      isDisabled = true;
      chat.addAll([
        Message(text: query, isUser: true),
        Message(isUser: false, isLoading: true)
      ]);
    });

    shouldScroll = true;
    final seed = DateTime.now().millisecondsSinceEpoch.toString();

    final response = await http.get(Uri.parse(
        "https://image.pollinations.ai/prompt/$query?seed=$seed"));

    if (response.statusCode == 200) {
      setState(() {
        isDisabled = false;
        chat.removeLast();
        chat.add(
          Message(
            image: response.bodyBytes,
            isUser: false,
            isLoading: false,
          ),
        );
      });
    } else {
      setState(() {
        isDisabled = false;
        chat.removeLast();
        chat.add(Message(isUser: false, image: null));
      });
    }
  }

  _saveImage(Uint8List byteData) async {
    ImageGallerySaverPlus.saveImage(byteData,
        quality: 60, name: DateTime.now().millisecondsSinceEpoch.toString());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 20;

    final callback = (ModalRoute.of(context)!.settings.arguments
        as Map)["callback"] as Function;

    if (shouldScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut));
      shouldScroll = false;
    }

    return Scaffold(
      backgroundColor: Color(0xFF010101),
      appBar: AppBar(
        backgroundColor: Color(0xFF010101),
        leadingWidth: 90,
        centerTitle: true,
        title: Text(
          "Your Chat",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: Color(0xFF242424)),
            onPressed: () {
              callback(chat
                  .map((item) => item.image)
                  .where((image) => image != null)
                  .toList());
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                Text(
                  "Back",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _controller,
                itemCount: chat.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => chat[index].isUser
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            constraints: BoxConstraints(maxWidth: width * 0.8),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF560FAB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              chat[index].text!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),
                            child: ClipOval(
                              child: Image(
                                image: AssetImage("assets/avatar.png"),
                                height: 40,
                                width: 40,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ClipOval(
                              child: Image(
                                image: AssetImage("assets/ai_avatar.jpg"),
                                height: 40,
                                width: 40,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.8 - 50),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF242424),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat[index].text == null
                                          ? chat[index].isLoading
                                              ? "Generating your image..."
                                              : "Here is the image you requested:"
                                          : chat[index].text!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    if (chat[index].text == null)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (chat[index].text == null)
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 56, 56, 56),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SizedBox(
                                          width: width * 0.8 - 70,
                                          height: width * 0.8 - 70,
                                          child: chat[index].isLoading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : chat[index].image == null
                                                  ? Center(
                                                      child: Text(
                                                        "Something went wrong. Try again!",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Image.memory(
                                                        chat[index].image!,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (chat[index].image != null)
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF242424),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () =>
                                        _saveImage(chat[index].image!),
                                    icon: Icon(
                                      Icons.download_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  suffixIcon: UnconstrainedBox(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () => _send(promptController.text),
                          icon: Icon(
                            Icons.send_rounded,
                            size: 20,
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                !isDisabled ? Color(0xFF560FAB) : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Color(0xFF242424),
                  hintText: "Enter your prompt...",
                  hintStyle: TextStyle(color: Colors.grey),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
              style: TextStyle(color: Colors.white),
              controller: promptController,
              textInputAction: TextInputAction.send,
              onSubmitted: (query) => _send(query),
              enabled: !isDisabled,
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  const Message(
      {this.text, required this.isUser, this.isLoading = false, this.image});

  final String? text;
  final bool isUser;
  final bool isLoading;
  final Uint8List? image;
}
