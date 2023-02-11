import 'dart:convert';
import 'dart:developer';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';
import 'package:video_player/video_player.dart';

class DashboardWidget extends StatefulWidget {
  // const DashboardWidget({super.key});
  List<Videos>? data;

  DashboardWidget({this.data});
  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final textController = TextEditingController(text: "");

  List<VideoPlayerController> myVideos = [];

  @override
  void initState() {
    super.initState();

    widget.data!.forEach((element) {
      myVideos.add(VideoPlayerController.network(
        element.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      ));
    });
    myVideos.forEach((controller) {
      controller.addListener(() {
        setState(() {});
      });
      controller.setLooping(true);
      controller.initialize();
    });
  }

  @override
  void dispose() {
    super.dispose();
    myVideos.forEach((controller) {
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appbar(),
          body: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  color: Colors.white,
                ),
                itemCount: widget.data!.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  VideoPlayerController controller = myVideos[index];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0XFFDBFFEE),
                      ),
                      height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.aspectRatio,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          caption(index),
                          time(index),
                          video(context, controller),
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          )),
    );
  }

  AppBar appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          "Explore",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: CircleAvatar(
              backgroundColor: Color(0xffE6EEFA),
              child: Icon(Icons.notifications_on, color: Colors.black)),
        ),
      ],
      leading: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: CircleAvatar(
            backgroundColor: Color(0xffE6EEFA),
            child: Icon(Icons.camera_alt_rounded, color: Colors.black)),
      ),
    );
  }

  Widget video(BuildContext context, VideoPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        height: MediaQuery.of(context).size.height * .4,
        width: double.infinity,
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(controller),
                    ClosedCaption(text: controller.value.caption.text),
                    _ControlsOverlay(controller: controller),
                    VideoProgressIndicator(controller, allowScrubbing: true),
                  ],
                ),
              )
            : Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.white,
                  rightDotColor: Colors.black.withOpacity(0.5),
                  // secondRingColor: Colors.white,
                  // thirdRingColor: Colors.black,
                  size: 50,
                ),
              ),

        // FlickManager(
        //   autoPlay: false,
        //   videoPlayerController:
        //       VideoPlayerController.network(
        //           widget.data![index].videoUrl),
        // ),
      ),
    );
  }

  Widget time(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(DateFormat.jm().format(widget.data![index].createdAt)),
    );
  }

  Widget caption(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(widget.data![index].caption),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
