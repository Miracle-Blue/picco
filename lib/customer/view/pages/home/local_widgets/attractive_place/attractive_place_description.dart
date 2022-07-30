import 'package:flutter/material.dart';
import 'package:picco/animations/down_to_up.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../../models/all_models.dart';

class AttractivePlaceDescription extends StatefulWidget {
  const AttractivePlaceDescription({Key? key}) : super(key: key);

  @override
  State<AttractivePlaceDescription> createState() =>
      _AttractivePlaceDescriptionState();
}

class _AttractivePlaceDescriptionState
    extends State<AttractivePlaceDescription> {
  bool back = false;
  late YoutubePlayerController controller;

  void startVideo() {
    final url =
        (ModalRoute.of(context)!.settings.arguments as AttractivePlaces).url;
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        loop: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as AttractivePlaces;
    startVideo();
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
      ),
      builder: (context, player) {
        return WillPopScope(
          onWillPop: () async {
            setState(() {
              back = true;
            });
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            extendBodyBehindAppBar: true,
            body: ListView(
              padding: const EdgeInsets.only(top: 0),
              children: [
                Hero(
                  tag: place.name,
                  child: Image.asset(place.image),
                ),
                const SizedBox(height: 30),
                back
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DownToUp(
                              delay: 0.8,
                              child: Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            DownToUp(
                              delay: 1.6,
                              child: Text(place.description),
                            ),
                            const SizedBox(height: 20),
                            DownToUp(
                                delay: 1.6,
                                child: Text(
                                  place.videoAboutDes,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            DownToUp(delay: 1.6, child: player),
                            const SizedBox(height: 20),
                            const DownToUp(
                                delay: 1.6,
                                child: Text(
                                  "Photo Zone",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            DownToUp(
                                delay: 1.6,
                                child: Text(place.photoDescription)),
                            DownToUp(
                              delay: 1.6,
                              child: Image.asset(place.extraImage),
                            ),
                            const SizedBox(height: 20),
                            DownToUp(
                              delay: 1.6,
                              child: Text(
                                place.extraImageDescription,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
