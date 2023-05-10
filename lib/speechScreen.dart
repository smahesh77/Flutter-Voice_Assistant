import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/api.dart';
import 'package:voice_assistant/catModel.dart';
import 'package:voice_assistant/colors.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechtotext = SpeechToText();
  var text = "Hold the button and start speaking";
  var isListening = false;
  final List<ChatMsg> messages = [];
  var scrollCon = ScrollController();

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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // to set it to center
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: -500),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (deets) async {
            if (!isListening) {
              var available = await speechtotext.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechtotext.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (deets) async {
            setState(() {
              isListening = false;
            });
            speechtotext.stop();

            messages.add(ChatMsg(text: text, type: ChatMsgType.user));
            var msg = await Api.sendMsg(text);
            setState(() {
              messages.add(ChatMsg(text: msg, type: ChatMsgType.bot));
            });
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(
              isListening
                  ? Icons.mic
                  : Icons
                      .mic_none, // to change the icon as per the value of islintening
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
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
            Text(
              text,
              style: TextStyle(
                  color: isListening ? Colors.black87 : Colors.black54,
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
            Icons.person,
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
