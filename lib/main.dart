import 'dart:ui';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(MaterialApp(home: Gemini(), debugShowCheckedModeBanner: false));
}

class Gemini extends StatefulWidget {
  const Gemini({super.key});

  @override
  State<Gemini> createState() => _GeminiState();
}

class _GeminiState extends State<Gemini> {
  final ChatUser cu = ChatUser(id: '1', firstName: "User");
  final ChatUser Gem = ChatUser(id: '2', firstName: "Echo");
  List<ChatMessage> msggg = <ChatMessage>[];
  String api = "AIzaSyBMWNfjOO_S2aEkBkoJ05pIcWiR0Em2c2A";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(bottomOpacity: 0,
          title: Text(
            "Echo",
            style:
                TextStyle(fontSize: 32, color: Colors.grey, fontFamily: "Echo"),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                  image:
                      AssetImage("Images/d5895ca5c927f1ed00e89de84edc2dd3.jpg"),
                  fit: BoxFit.fill),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              // Adjust sigmaX and sigmaY for blur intensity
              child: Container(
                color:
                    Colors.black.withOpacity(0.2), // Adjust opacity as needed
              ),
            ),
            DashChat(
                messageOptions: MessageOptions(
                    containerColor: Colors.white38,
                    textColor: Colors.black,
                    currentUserContainerColor: Colors.white24,
                    currentUserTextColor: Colors.grey),
                currentUser: cu,
                onSend: (ChatMessage m) {
                  Gemtalk(m);
                },
                messages: msggg),
          ],
        ),
      ),
    );
  }

  Future<void> Gemtalk(ChatMessage m) async {
    final a = GenerativeModel(model: "gemini-pro", apiKey: api);
    final content = Content.text(m.text);
    final r = await a.generateContent([content]);
    print(r.text);
    setState(() {
      msggg.insert(0, m);
    });
    setState(() {
      msggg.insert(
          0,
          ChatMessage(
              user: Gem,
              text: r.text.toString(),
              createdAt: DateTime.timestamp()));
    });
  }
}
