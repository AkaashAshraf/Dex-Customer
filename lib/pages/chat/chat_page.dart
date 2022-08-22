// import 'dart:io';

 // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:community_material_icon/community_material_icon.dart';
// import 'package:customers/providers/services/media_pick.dart';
// import 'package:customers/repositories/api_keys.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
 
// class ChatPage extends StatefulWidget {
//   final String type;
//   final String rID;
//   final String rName;
//   final String rImage;
//   final String chatID;

//   ChatPage({
//     this.type,
//     this.rID,
//     this.rName,
//     this.rImage,
//     this.chatID,
//   });

//   @override
//   ChatPageState createState() {
//     return new ChatPageState();
//   }
// }

// class ChatPageState extends State<ChatPage> {
//   final db = Firestore.instance;
//   CollectionReference chatReference;
//   final TextEditingController _textController = new TextEditingController();
//   bool isLoading = false;
//   var userId;
//   var userImage;
//   var userPhone;
//   var userName;

//   @override
//   void initState() {
//     super.initState();
//     init();
//     chatReference =
//         db.collection("chats").document(widget.chatID).collection('messages');
//   }

//   void init() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     userId = pref.getString('userId');
//     userImage = pref.getString('userImage');
//     userPhone = pref.getString('userPhone');
//     userName = pref.getString('userName');
//   }

//   List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
//     return <Widget>[
//       new Material(
//         borderRadius: BorderRadius.circular(50),
//         color: Theme.of(context).secondaryHeaderColor,
//         child: Container(
//           margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
//           child: new Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               new Text(documentSnapshot.data['sender_name'],
//                   style: new TextStyle(
//                       fontSize: 14.0,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold)),
//               documentSnapshot.data['image_url'] != ''
//                   ? InkWell(
//                       child: new Container(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => FullScreenImage(
//                                         documentSnapshot.data['image_url'])));
//                           },
//                           child: Hero(
//                             tag: documentSnapshot.data['image_url'],
//                             child: Image.network(
//                               documentSnapshot.data['image_url'],
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ),
//                         ),
//                         height: 150,
//                         width: 150.0,
//                         color: Color.fromRGBO(0, 0, 0, 0.2),
//                         padding: EdgeInsets.all(5),
//                       ),
//                       onTap: () {},
//                     )
//                   : new Text(
//                       documentSnapshot.data['text'],
//                       style: TextStyle(color: Colors.white),
//                     ),
//             ],
//           ),
//         ),
//       ),
//       new Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           new Container(
//               margin: const EdgeInsets.only(left: 8.0),
//               child: new CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: new NetworkImage(
//                     APIKeys.ONLINE_IMAGE_BASE_URL +
//                         documentSnapshot.data['profile_photo']),
//               )),
//         ],
//       ),
//     ];
//   }

//   List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
//     return <Widget>[
//       new Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           new Container(
//               margin: const EdgeInsets.only(right: 8.0),
//               child: new CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: new NetworkImage(
//                     APIKeys.ONLINE_IMAGE_BASE_URL +
//                         documentSnapshot.data['profile_photo']),
//               )),
//         ],
//       ),
//       new Material(
//         borderRadius: BorderRadius.circular(50),
//         color: Theme.of(context).secondaryHeaderColor,
//         child: Center(
//           child: Container(
//             margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
//             child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 new Text(
//                     documentSnapshot.data['receiver_name'] == ""
//                         ? "Undefined"
//                         : documentSnapshot.data['receiver_name'],
//                     style: new TextStyle(
//                         fontSize: 14.0,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold)),
//                 new Container(
//                   margin: const EdgeInsets.only(top: 5.0),
//                   child: documentSnapshot.data['image_url'] != ''
//                       ? InkWell(
//                           child: new Container(
//                             child: Image.network(
//                               documentSnapshot.data['image_url'],
//                               fit: BoxFit.fitWidth,
//                             ),
//                             height: 150,
//                             width: 150.0,
//                             color: Color.fromRGBO(0, 0, 0, 0.2),
//                             padding: EdgeInsets.all(5),
//                           ),
//                           onTap: () {},
//                         )
//                       : new Text(documentSnapshot.data['text']),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ];
//   }

//   generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
//     return snapshot.data.documents
//         .map<Widget>((doc) => Container(
//             margin: const EdgeInsets.symmetric(vertical: 10.0),
//             child: doc.data['sender_id'] != userId.toString()
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: generateReceiverLayout(doc))
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: generateSenderLayout(doc))))
//         .toList();
//   }

//   File imageFile;

//   void getImage() async {
//     var pickedFile = await showDialog(
//         context: context, builder: (context) => MediaPickDialog());
//     if (pickedFile != null)
//       setState(() {
//         imageFile = pickedFile;
//         if (imageFile != null) {
//           setState(() {});
//           uploadFile(imageFile);
//         }
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(widget.rName),
//         centerTitle: true,
//         leading: IconButton(
//             icon: Icon(CommunityMaterialIcons.arrow_left, color: Colors.black),
//             onPressed: () => Navigator.pop(context)),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Container(
//           padding: EdgeInsets.all(5),
//           child: new Column(
//             children: <Widget>[
//               StreamBuilder<QuerySnapshot>(
//                 stream:
//                     chatReference.orderBy('time', descending: true).snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasData)
//                     return new Expanded(
//                       child: new ListView(
//                         reverse: true,
//                         children: generateMessages(snapshot),
//                       ),
//                     );
//                   return Expanded(
//                     child: new Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Icon(
//                             Icons.no_sim,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Text("لا توجد رسائل فس هذه المحادثة")
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               new Divider(height: 1.0),
//               new Container(
//                 decoration:
//                     new BoxDecoration(color: Theme.of(context).cardColor),
//                 child: _buildTextComposer(),
//               ),
//               new Builder(builder: (BuildContext context) {
//                 return new Container(width: 0.0, height: 0.0);
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconButton getDefaultSendButton() {
//     return new IconButton(
//         icon: new Icon(Icons.send,
//             color: !isLoading ? Theme.of(context).accentColor : Colors.grey),
//         onPressed: !isLoading ? () => _sendText(2) : null,
//         color: !isLoading ? Theme.of(context).accentColor : Colors.grey);
//   }

//   Widget _buildTextComposer() {
//     return new IconTheme(
//         data: new IconThemeData(
//           color: !isLoading ? Theme.of(context).accentColor : Colors.grey,
//         ),
//         child: new Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: new Row(
//             children: <Widget>[
//               /*new Container(
//                 margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                 child: new IconButton(
//                     icon: new Icon(
//                       Icons.photo_camera,
//                       color: Theme.of(context).accentColor,
//                     ),
//                     onPressed: () async {
//                       var image = await ImagePicker.pickImage(
//                           source: ImageSource.gallery);
//                       int timestamp = new DateTime.now().millisecondsSinceEpoch;
//                       StorageReference storageReference = FirebaseStorage
//                           .instance
//                           .ref()
//                           .child('chats/img_' + timestamp.toString() + '.jpg');
//                       StorageUploadTask uploadTask =
//                       storageReference.putFile(image);
//                       await uploadTask.onComplete;
//                       String fileUrl = await storageReference.getDownloadURL();
//                       _sendImage(messageText: null, imageUrl: fileUrl);
//                     }),
//               ),*/
//               Material(
//                 child: new Container(
//                   margin: new EdgeInsets.symmetric(horizontal: 1.0),
//                   child: new IconButton(
//                       icon: new Icon(
//                         Icons.image,
//                       ),
//                       onPressed: () async {
//                         isLoading ? null : getImage();
//                       }, // getSticker,
//                       color: !isLoading
//                           ? Theme.of(context).accentColor
//                           : Colors.grey),
//                 ),
//                 color: Colors.white,
//               ),
//               new Flexible(
//                 child: new TextField(
//                   textAlign: TextAlign.right,
//                   controller: _textController,
//                   onChanged: (String messageText) {
//                     setState(() {
//                       // isLoading = messageText.length > 0;
//                     });
//                   },
//                   onSubmitted: _sendText,
//                   decoration:
//                       new InputDecoration.collapsed(hintText: "ارسل رسالة"),
//                 ),
//               ),
//               new Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: getDefaultSendButton(),
//               ),
//             ],
//           ),
//         ));
//   }

//   String imageUrl;

//   Future uploadFile(image) async {
//     setState(() {
//       isLoading = true;
//     });
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//     StorageUploadTask uploadTask = reference.putFile(image);
//     StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//     storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//       imageUrl = downloadUrl;
//       setState(() {
//         // isLoading = false;

 //         _sendText(1);
//       });
//     }, onError: (err) {
//       setState(() {
//         // isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'This file is not an image');
//     });
//   }

//   Future<Null> _sendText(type) async {
//     var message = _textController.text;
//     setState(() {
//       _textController.clear();

//     });
 

//     if (type == 1) {
//       chatReference.add({
//         'text': '',
//         'sender_id': userId.toString(),
//         'sender_name': userName,
//         'receiver_id': widget.rID,
//         'receiver_name': widget.rName,
//         'profile_photo': userImage,
//         'receiver_profile': widget.rImage,
//         'image_url': imageUrl,
//         'time': FieldValue.serverTimestamp(),
//       }).then((documentReference) {
//         sendNoti('  صورة', userName, '  صورة', userName);

 //         setState(() {
//           isLoading = false;
//         });
//       }).catchError((e) {
//         setState(() {
//           isLoading = false;
//         });
//       });
//     } else {
//       if (message == "") {
//         FocusScope.of(context).unfocus();
//       } else {
//         chatReference.add({
//           'text': message,
//           'sender_id': userId.toString(),
//           'sender_name': userName,
//           'receiver_id': widget.rID,
//           'receiver_name': widget.rName,
//           'profile_photo': userImage,
//           'receiver_profile': widget.rImage,
//           'image_url': '',
//           'time': FieldValue.serverTimestamp(),
//         }).then((documentReference) {
//           sendNoti(
//               message, userName, message, userName);

//           setState(() {
//             _textController.clear();
//             message = '' ;
//             isLoading = false;
//           });
//         }).catchError((e) {
//           setState(() {
//             isLoading = false;
//           });
//         });
//       }
//     }
//   }
 

//   Future<void> sendNoti(dataBody, dataTit, notiBody, notiTit) async {
//     try {
//       // loadinsg = true;

//       print(
//           'http://80.211.24.15/api/fire/userId&${widget.rID}/title&$/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
//       var response = await Dio().get(
//           'http://80.211.24.15/api/fire/userId&${widget.rID}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');

//       print(response.data);
//     } catch (e) {}
//   }

//   void _sendImage({String messageText, String imageUrl}) {
//     chatReference.add({
//       'text': messageText,
//       'sender_id': "",
//       'sender_name': "",
//       'receiver_id': "",
//       'receiver_name': "",
//       'profile_photo': "",
//       'image_url': imageUrl,
//       'time': FieldValue.serverTimestamp(),
//     });
//   }
// }

// class FullScreenImage extends StatelessWidget {
//   var image;

//   FullScreenImage(this.image);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       child: Center(
//         child: Hero(
//           tag: image,
//           child: Image.network(
//             image,
//             fit: BoxFit.fill,
//           ),
//         ),
//       ),
//     );
//   }
// }
