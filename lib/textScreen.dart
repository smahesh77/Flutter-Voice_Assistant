import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/api.dart';
import 'package:voice_assistant/chatModel.dart';
import 'package:voice_assistant/colors.dart';
import 'package:voice_assistant/speechScreen.dart';

class textScreen extends StatefulWidget {
  const textScreen({super.key});

  @override
  State<textScreen> createState() => _textScreenState();
}

class _textScreenState extends State<textScreen> {
  SpeechToText speechtotext = SpeechToText();
  var text;
  var isListening = false;
  final List<ChatMsg> messages = [];
  var scrollCon = ScrollController();
  var qCon = TextEditingController();

  scrolMeth() {
    scrollCon.animateTo(
      scrollCon.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Voice input'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SpeechScreen()));
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // to set it to center
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort_rounded)),
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          "Stealing GPT",
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      body: Container(
        //color: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            const Text(
              "Enter your question",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: chatBgColor,
                    borderRadius: BorderRadius.circular(12)),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: messages.length,
                  shrinkWrap: true,
                  controller: scrollCon,
                  itemBuilder: (BuildContext context, int index) {
                    var chat = messages[index];
                    return chatBubble(chatText: chat.text, type: chat.type);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: qCon,
              decoration: InputDecoration(hintText: "enter your qurstion here"),
            ),
            IconButton(
                splashRadius: 20,
                onPressed: () async {
                  text = qCon.text;
                  messages.add(ChatMsg(text: text, type: ChatMsgType.user));
                  var msg = await Api.sendMsg(text);
                  setState(() {
                    messages.add(ChatMsg(text: msg, type: ChatMsgType.bot));
                  });
                  qCon.clear();
                },
                icon: const Icon(Icons.send)),
                
            const Text(
              'Developed by The Dot Company',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required chatText, required ChatMsgType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(
            type == ChatMsgType.bot ? Icons.android : Icons.person,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Text(
              '$chatText',
              style: TextStyle(
                  color: chatBgColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
