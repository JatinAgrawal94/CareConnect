import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class DisplayVideo extends StatefulWidget {
  final File video;
  DisplayVideo({Key key, this.video}) : super(key: key);

  @override
  State<DisplayVideo> createState() => _DisplayVideoState(this.video);
}

class _DisplayVideoState extends State<DisplayVideo> {
  VideoPlayerController _controller;
  final File video;

  _DisplayVideoState(this.video);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(video)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Video Player"), backgroundColor: Colors.deepPurple),
        body: Container(
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
          backgroundColor: Colors.deepPurple,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ));
  }
}
