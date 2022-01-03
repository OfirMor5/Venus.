import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_grpc/v2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hera2/utils/dialogflow_response_parameters.dart';
import 'package:hera2/widgets/chat_message.dart';
import 'package:dialogflow_grpc/dialogflow_auth.dart';
import 'package:hera2/widgets/typing_indicator.dart';
import '../models/user_details.dart';

class Chatbot extends StatefulWidget {
  Chatbot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Chatbot createState() => new _Chatbot();
}

class _Chatbot extends State<Chatbot> {
  bool _isTyping = false;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<UserDetails> fetchUserDetails() async {
    var query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    return UserDetails.fromMap(query.data());
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Padding(
          padding: EdgeInsets.all(5),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: FaIcon(FontAwesomeIcons.solidPaperPlane),
                    onPressed: () => _handleSubmitted(_textController.text)),
              ),
            ],
          ),
        ),
      ),
    );
  }

// ignore: non_constant_identifier_names
  void Response(query) async {
    _textController.clear();
    setState(() {
      _isTyping = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/hera-95326-7fb2fc80461e.json'))}');

    DialogflowGrpcV2 dialogflow =
        DialogflowGrpcV2.viaServiceAccount(serviceAccount);
    var data = await dialogflow.detectIntent(query, 'en-US');
    if (data != null && data.hasQueryResult()) {
      String response =
          await _findAndReplaceParameters(data.queryResult.fulfillmentText);

      ChatMessage message = new ChatMessage(
        text: response,
        name: "Venus",
        type: false,
      );
      setState(() {
        _isTyping = false;
        _messages.insert(0, message);
      });
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text != null && text.isNotEmpty) {
      ChatMessage message = new ChatMessage(
        text: text,
        name: user.displayName,
        type: true,
      );
      setState(() {
        _messages.insert(0, message);
      });
      Response(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        Align(
          alignment: Alignment.bottomLeft,
          child: TypingIndicator(
            showIndicator: _isTyping,
          ),
        ),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  Future<String> _findAndReplaceParameters(String fulfillmentText) async {
    UserDetails userDetails = await fetchUserDetails();

    if (fulfillmentText
        .contains(DialogflowResponseParameters.displayNameParameter)) {
      fulfillmentText = fulfillmentText.replaceAll(
          DialogflowResponseParameters.displayNameParameter, user.displayName);
    }
    if (fulfillmentText
        .contains(DialogflowResponseParameters.dueDateParameters)) {
      fulfillmentText = fulfillmentText.replaceAll(
          DialogflowResponseParameters.dueDateParameters,
          userDetails.dueDate.toString().split(' ').first);
    }
    return fulfillmentText;
  }
}
