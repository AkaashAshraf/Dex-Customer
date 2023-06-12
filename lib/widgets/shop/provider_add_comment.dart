import 'package:flutter/material.dart';

class ProviderAddComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //   return Column(
    //     children: <Widget>[
    //       commentLoading == true
    //           ? Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Center(
    //                 child: CircularProgressIndicator(
    //                   backgroundColor: Theme.of(context).accentColor,
    //                 ),
    //               ),
    //             )
    //           : Container(),
    //       Container(
    //         margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 3),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //         ),
    //         child: new TextField(
    //           decoration: InputDecoration(
    //             hintText: 'writeComment'.tr(),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(4)),
    //               borderSide: BorderSide(
    //                   width: 1, color: Theme.of(context).secondaryHeaderColor),
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(4)),
    //               borderSide:
    //                   BorderSide(width: 2, color: Theme.of(context).accentColor),
    //             ),
    //           ),
    //           maxLines: null,
    //           keyboardType: TextInputType.multiline,
    //           textAlign: TextAlign.center,
    //           controller: myComment,
    //         ),
    //       ),
    //       FlatButton(
    //         onPressed: () {
    //           if (myComment.text.length != 0) {
    //             addComment(myComment.text.trim());
    //             myComment.clear();
    //           }
    //         },
    //         child: Container(
    //           height: 40,
    //           margin: EdgeInsets.only(left: 10, right: 10, top: 0),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5),
    //             color: Theme.of(context).accentColor,
    //           ),
    //           child: Center(
    //             child: Text(
    //               'comment',
    //               style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.w600),
    //             ).tr(),
    //           ),
    //         ),
    //       ),
    //     ],
    //   );
  }
}
