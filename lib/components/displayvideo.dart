import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class DisplayVideo extends StatefulWidget {
  final File video;
  final String videoURL;

  DisplayVideo({Key key, this.video, this.videoURL}) : super(key: key);

  @override
  State<DisplayVideo> createState() => _DisplayVideoState(
        this.video,
        this.videoURL,
      );
}

class _DisplayVideoState extends State<DisplayVideo> {
  VideoPlayerController _controller;
  final File video;
  final String videoURL;

  _DisplayVideoState(this.video, this.videoURL);
  @override
  void initState() {
    super.initState();
    if (videoURL == null) {
      _controller = VideoPlayerController.file(video)
        ..initialize().then((_) {
          setState(() {}); //when your thumbnail will show.
        });
    } else {
      _controller = VideoPlayerController.network(videoURL)
        ..initialize().then((_) {
          setState(() {}); //when your thumbnail will show.
        });
    }
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
