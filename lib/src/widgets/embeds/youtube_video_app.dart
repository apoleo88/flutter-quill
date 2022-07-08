import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../flutter_quill.dart';

class YoutubeVideoApp extends StatefulWidget {
  const YoutubeVideoApp(
      {required this.videoUrl, required this.context, required this.readOnly});
  // this.autoPlay,
  // this.fullScreenAllowed,

  final String videoUrl;
  final BuildContext context;
  final bool readOnly;

  @override
  _YoutubeVideoAppState createState() => _YoutubeVideoAppState();
}

class _YoutubeVideoAppState extends State<YoutubeVideoApp> {
  var _youtubeController;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      bool fullScreenAllowed = true;
      bool autoPlay = true;
      YouTubeSettings? yts = Provider.of<YouTubeSettings?>(context, listen: false);
      if(yts != null){
        autoPlay = yts.autoPlay;
        fullScreenAllowed = yts.fullScreenAllowed;
      }

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: autoPlay,
          showLiveFullscreenButton: fullScreenAllowed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyles = DefaultStyles.getInstance(context);
    if (_youtubeController == null) {
      if (widget.readOnly) {
        return RichText(
          text: TextSpan(
              text: widget.videoUrl,
              style: defaultStyles.link,
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(Uri.parse(widget.videoUrl))),
        );
      }

      return RichText(
          text: TextSpan(text: widget.videoUrl, style: defaultStyles.link));
    }

    return Container(
      height: 300,
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
        ),
        builder: (context, player) {
          return Column(
            children: [
              // some widgets
              player,
              //some other widgets
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _youtubeController.dispose();
  }
}

class YouTubeSettings{
  final bool autoPlay;
  final bool fullScreenAllowed;

  YouTubeSettings({
    required this.autoPlay,
    required this.fullScreenAllowed,
  });
}