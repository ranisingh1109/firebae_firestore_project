import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
   VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  File? selectedVideo;
  List<File> video = <File>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Screen"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        takeMultiVideo();
      },child: Icon(Icons.add),),
      body: StreamBuilder(
        stream: getUploadedVideo(),
        builder: (context, snapshot) {
          var video = snapshot.data?.docs;
          if (video?.isNotEmpty == true) {
            return ListView.builder(
              itemCount: video?.length,
              itemBuilder: (context, index) {
                return  Container(
                  height: 800,
                  width: 100,
                  color: Colors.blue,
                  child: VideoApp(videoUrl: video![index]['url'],),
                  //
                );

              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  takeMultiVideo() async {
    FilePickerResult? pikerVideo = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video
    );
    if (pikerVideo != null) {
      var file = pikerVideo.files.map((path) => File(path.path!)).toList();
      for (var multiVideo in file) {
        uploadVideo(multiVideo);
        print(multiVideo.path);
      }
      // setState(() {
      //   image.addAll(file);
      // });
      print(file.first.path);
    } else {}
  }

  uploadVideo(File file) async{
    var storage = await FirebaseStorage.instance;
    storage
        .ref("FOLDER-IMAGE")
        .child(file.path.split("/").last)
        .putFile(File(file.path))
        .then((value) async {
      var imageUrl = await value.ref.getDownloadURL();
      print(imageUrl);
      FirebaseFirestore.instance.collection("videos").add({"url": imageUrl});
      Fluttertoast.showToast(msg: "Video uploaded");
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUploadedVideo() {
    var instance = FirebaseFirestore.instance.collection("videos");
    return instance.snapshots();
  }


}



class VideoApp extends StatefulWidget {
  final String videoUrl;
  const VideoApp({super.key, required this.videoUrl});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
