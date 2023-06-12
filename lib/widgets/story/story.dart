// import 'package:customers/models/shops.dart';
// import 'package:customers/models/special_offer.dart';
// import 'package:customers/models/story/shop_story.dart';
// import 'package:customers/pages/shop/provider_page.dart';
// import 'package:customers/repositories/api_keys.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:story_view/controller/story_controller.dart';
// import 'package:story_view/story_view.dart';
// import 'package:story_view/widgets/story_view.dart';

// class StoryWidget extends StatefulWidget {
//   final Shop shop;
//   final List<Story> story;

//   const StoryWidget({Key key, this.shop, this.story}) : super(key: key);
//   @override
//   _StoryWidgetState createState() => _StoryWidgetState();
// }

// class _StoryWidgetState extends State<StoryWidget> {
//   StoryController storyController = StoryController();

//   strList(Story story) {
//     List<dynamic> str =
//         story.textList.length >= 2 ? story.textList : story.textList[0];
//     List<TextSpan> list = [];
//     if (str[0] != null) {
//       list.add(TextSpan(
//           text: str[0],
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//           )));
//     }
//     if (story.mentionedName != null) {
//       list.add(TextSpan(
//           text: " @${story.mentionedName} ",
//           recognizer: TapGestureRecognizer()
//             ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => ProviderScreen(
//                       from: 'special',
//                       specialOffer: SpecialOffer(shopId: story.mentionedId),
//                     ))),
//           style: TextStyle(
//               color: Theme.of(context).secondaryHeaderColor,
//               fontSize: 15,
//               decoration: TextDecoration.underline)));
//     }
//     if (str[1] != null) {
//       list.add(TextSpan(
//           text: str[1],
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//           )));
//     }
//     return list;
//   }

//   List<StoryItem> stories(List<Story> list) {
//     List<StoryItem> s = [];
//     for (int i = 0; i < list.length; i++) {
//       s.add(
//         StoryItem.inlineImage(
//           imageFit: BoxFit.contain,
//           caption: Text("${list[i].textList[0]} ${list[i].textList[1]}",
//                   style: TextStyle(fontSize: 20, color: Colors.white)),
//           duration: Duration(seconds: 10),
//           url: APIKeys.ONLINE_IMAGE_BASE_URL + list[i].storyImage.toString(),
//           controller: storyController,
//         ),
//       );
//     }
//     return s;
//   }

//   int index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       children: [
//         StoryView(
//             controller: storyController,
//             storyItems: stories(widget.story),
//             onComplete: () {
//               Navigator.pop(context);
//               index++;
//             },
//             onVerticalSwipeComplete: (direction) {
//               if (direction == Direction.down) {
//                 Navigator.pop(context);
//                 index++;
//               }
//             }),
//       ],
//     ));
//   }
// }
