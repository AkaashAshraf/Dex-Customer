import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/models/special_offer.dart';
import 'package:customers/models/story/shop_story.dart';
import 'package:customers/pages/shop/provider_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:easy_localization/easy_localization.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> story;
  final Shop user;
  final int index;
  const StoryScreen({Key key, this.story, this.user, this.index})
      : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with TickerProviderStateMixin {
  PageController _pageController;
  AnimationController _animController;
  VideoPlayerController _videoController;
  File file;
  bool _isLoading = false;
  Uint8List thumbNail;
  int _currentIndex = 0;

  picStory(String url) async {
    var _check = await DefaultCacheManager().getFileFromCache(url);
    if (_check == null) {
      return CachedNetworkImage(
        imageUrl: url,
        progressIndicatorBuilder: (context, url, progress) {
          if (progress != null && progress.progress == 1) {
            _animController?.forward();
          }
          return CircularProgressIndicator(value: progress.progress);
        },
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/dex.png'),
      );
    }
    if (_check != null) {
      _animController?.forward();
      return Image.file(_check.file, fit: BoxFit.contain);
    }
    return CircularProgressIndicator();
  }

  Future<File> checkForUrl(String url) async {
    var file = await DefaultCacheManager().getFileFromCache(url);
    return file.file;
  }

  Row row() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.white,
          backgroundImage: widget.user != null
              ? CachedNetworkImageProvider(
                  APIKeys.ONLINE_IMAGE_BASE_URL + widget.user?.image.toString(),
                )
              : AssetImage('assets/images/dex.png'),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            widget.user?.name ?? "DEX",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            _animController.removeStatusListener((status) {});
            _videoController?.removeListener(() {});
            _videoController?.pause();
            _videoController = VideoPlayerController.asset('');
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController = PageController();
      _animController =
          AnimationController(vsync: this, duration: Duration(seconds: 1));

      final Story firstStory = widget.story.first;
      _loadStory(story: firstStory, animateToPage: false);

      _animController?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animController?.stop();
          _animController?.reset();
          if (_currentIndex + 1 < widget.story.length) {
            _currentIndex += 1;
            _loadStory(story: widget.story[_currentIndex]);
          } else {
            _animController.removeStatusListener((status) {});
            _videoController?.removeListener(() {});
            _videoController?.pause();
            _videoController = VideoPlayerController.asset('');
            _videoController = null;
            Navigator.of(context).pop();
          }
        }
      });
    });
  }

  Future<bool> _onwillPop() {
    _animController.removeStatusListener((status) {});
    _animController?.dispose();
    _videoController?.pause();
    _videoController?.removeListener(() {});
    _videoController = VideoPlayerController.asset('');
    _videoController = null;
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) { 
    log('sotries length: '+ widget.story.length.toString());
    final Story story = widget.story[_currentIndex];
    return WillPopScope(
      onWillPop: _onwillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onTapDown: (details) => _onTapDown(details, story),
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                pageSnapping: false,
                controller: _pageController,
                itemCount: widget.story.length,
                itemBuilder: (context, i) {
                  final Story story = widget.story[i];
                  switch (story.type) {
                    case StoryType.img:
                      var url = APIKeys.ONLINE_IMAGE_BASE_URL +
                          story.storyImage.toString();
                      return FutureBuilder(
                          future: checkForUrl(url),
                          builder: (context, snap) {
                            if (snap.data == null) {
                              return CachedNetworkImage(
                                imageUrl: url,
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  if (progress != null &&
                                      progress.progress == 1) {
                                    _animController?.forward();
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                        value: progress.progress,
                                        color: Colors.grey),
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/dex.png'),
                              );
                            } else if (snap.data != null) {
                              _animController.forward();
                              return Image.file(snap.data);
                            }
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.grey));
                          });
                      // CachedNetworkImage(
                      //   imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                      //       story.storyImage.toString(),
                      //   placeholder: (context, url) => Center(
                      //       child:
                      //           CircularProgressIndicator(color: Colors.grey)),
                      //   errorWidget: (context, url, error) =>
                      //       Image.asset('assets/images/dex.png'),
                      //   fit: BoxFit.contain,
                      // );
                      break;
                    case StoryType.vid:
                      if (_videoController != null &&
                          _videoController.value.isInitialized) {
                        return Stack(
                          children: [
                            Center(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _videoController.value.size.width,
                                  height: _videoController.value.size.height,
                                  child: VideoPlayer(_videoController),
                                ),
                              ),
                            ),
                            _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                                : SizedBox()
                          ],
                        );
                      } else {
                        if (thumbNail == null || _isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              Center(
                                child: Image(
                                    fit: BoxFit.contain,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    image: MemoryImage(thumbNail)),
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                    color: Colors.grey),
                              )
                            ],
                          );
                        }
                      }
                      break;
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: [
                  Row(
                    children: widget.story
                        .asMap()
                        .map((i, e) {
                          return MapEntry(
                            i,
                            AnimatedBar(
                              animController: _animController ??
                                  AnimationController(vsync: this),
                              position: i,
                              currentIndex: _currentIndex,
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: row(),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 0.0,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: .3,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        color: Colors.grey[800],
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                              maxLines: null,
                              text: TextSpan(children: [
                                if (story.textList[0] != null)
                                  TextSpan(
                                      text: story.textList[0],
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                if (story.mentionedName != null &&
                                    story.mentionedName != '')
                                  TextSpan(
                                    text: "@${story.mentionedName.toString()}",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProviderScreen(
                                                    from: 'special',
                                                    specialOffer: SpecialOffer(
                                                        shopId:
                                                            story.mentionedId),
                                                  ))),
                                  ),
                                if (story.textList[1] != null)
                                  TextSpan(
                                      text: story.textList[1],
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                              ])),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _cacheVid(String url) async {
    file = await DefaultCacheManager().getSingleFile(url, key: url);
    print('================== VIDEO SAVED');
  }

  _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (context.locale == Locale('en')) {
          if (_currentIndex - 1 >= 0) {
            _currentIndex -= 1;
            _loadStory(story: widget.story[_currentIndex]);
          }
        } else {
          if (_currentIndex + 1 < widget.story.length) {
            _currentIndex += 1;
            _loadStory(story: widget.story[_currentIndex]);
          } else {
            _animController.removeStatusListener((status) {});
            _videoController?.removeListener(() {});
            _videoController?.pause();
            _videoController = VideoPlayerController.asset('');
            _videoController = null;
            Navigator.of(context).pop();
          }
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (context.locale == Locale('en')) {
          if (_currentIndex + 1 < widget.story.length) {
            _currentIndex += 1;
            _loadStory(story: widget.story[_currentIndex]);
          } else {
            _animController.removeStatusListener((status) {});
            _videoController?.removeListener(() {});
            _videoController?.pause();
            _videoController = VideoPlayerController.asset('');
            _videoController = null;
            Navigator.of(context).pop();
          }
        } else {
          if (_currentIndex - 1 >= 0) {
            _currentIndex -= 1;
            _loadStory(story: widget.story[_currentIndex]);
          }
        }
      });
    } else {
      if (story.type == StoryType.vid) {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
          _animController?.stop();
        } else {
          _videoController?.play();
          _animController?.forward();
        }
      }
    }
  }

  Future _getThumNail(String url) async {
    try {
      thumbNail = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.PNG,
        maxHeight: 64,
        quality: 5,
      );
    } on Exception catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initVid(String url) async {
    Future.delayed((Duration.zero), () async {
      _getThumNail(url);
      _cacheVid(url);
    });
  }

  void _playNetWorkVidVid(String url) {
    _videoController = VideoPlayerController.network(url)
      ..addListener(() async {
        if (_videoController != null && _videoController.value.isInitialized) {
          _animController.duration = _videoController.value.duration;
          if (_videoController.value.isBuffering) {
            setState(() {
              _isLoading = true;
              print('==================== loading...');
              if (_videoController.value.isPlaying) {
                _videoController.pause();
                _animController?.stop();
              }
            });
          } else if (!_videoController.value.isBuffering) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                if (!_videoController.value.isPlaying) {
                  _videoController?.play();
                  _animController?.forward();
                }
              });
            }
          }
        }
      })
      ..initialize().then((value) {
        print('===============iniitlized');
      });
  }

  void _playCahchedVid(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((value) {
        setState(() {
          _isLoading = false;
          if (_videoController != null) {
            _animController?.duration = _videoController.value.duration;
            _animController?.forward();
            _videoController?.play();
          }
        });
      });
  }

  void _loadStory({Story story, bool animateToPage = true}) async {
    if (animateToPage) {
      _pageController?.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );

      setState(() {
        _videoController?.pause();
        _videoController?.removeListener(() {});
        if (_videoController != null && _videoController.value.isInitialized) {
          _videoController = VideoPlayerController.asset('');
        }
        _videoController = null;
        file = null;
        thumbNail = null;
      });
    }
    _animController?.stop();
    _animController?.reset();
    switch (story.type) {
      case StoryType.img:
        _animController?.duration = Duration(seconds: 10);
        setState(() {});
        break;
      case StoryType.vid:
        String url = APIKeys.ONLINE_IMAGE_BASE_URL + story.storyVid.toString();
        var _check = await DefaultCacheManager().getFileFromCache(url);
        if (_check == null) {
          _initVid(url);
          _playNetWorkVidVid(url);
        } else {
          _playCahchedVid(url);
        }
        break;
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key key,
    @required this.animController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final Shop user;

  const UserInfo({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.white,
          backgroundImage: user != null
              ? CachedNetworkImageProvider(
                  APIKeys.ONLINE_IMAGE_BASE_URL + user?.image.toString(),
                )
              : AssetImage('assets/images/dex.png'),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            user?.name ?? "DEX",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
