import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String deviceId;

  const ChatScreen({super.key, required this.name, required this.deviceId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: getMessage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data?.snapshot.children.toList();
                  return data?.isNotEmpty != null
                      ? ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            var message = data[index].value as Map;
                            var senderId = message["sendId"];
                            var messageId = data[index].key;
                            return InkWell(
                              onLongPress: () {
                                deleteMessage(messageId!);
                              },
                              child: senderId == widget.deviceId
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: messageView(message),
                                    )
                                  : Align(
                                      alignment: Alignment.bottomLeft,
                                      child: messageView(message),
                                    ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("No message found!"),
                        );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.indigo),
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Type message....",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal,
                      child: IconButton(
                          onPressed: () {
                            addMessage(messageController.text.trim());
                          },
                          icon: const Center(
                              child: Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.white,
                          )))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget messageView(Map<dynamic, dynamic> message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['name'] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message['message'] ?? ""),
            Text(
              message['dateTime'].toString(),
              style: const TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }

  addMessage(String message) async {
    var realTime = await FirebaseDatabase.instance.ref("chats");
    var id = realTime.push().key;
    realTime.child(id.toString()).set({
      "id": id.toString(),
      "name": widget.name,
      "sendId": widget.deviceId,
      "message": message,
      "dateTime": DateTime.now().toString(),
    }).then((value) {
      messageController.clear();
    });
  }

  Stream<DatabaseEvent> getMessage() {
    var realTime = FirebaseDatabase.instance.ref("chats");
    return realTime.onValue;
  }

  deleteMessage(String messageId) async {
    var realTime =
        await FirebaseDatabase.instance.ref("chats").child(messageId);
    await realTime.remove();
  }
}
