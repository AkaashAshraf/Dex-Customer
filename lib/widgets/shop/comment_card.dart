import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:customers/models/shops.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CommentCard extends StatelessWidget {
  final ShopsComments comment;
  CommentCard({this.comment});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
            child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10, right: 20),
                      child: Text(
                        comment.userInfo != null
                            ? comment.userInfo.firstName != null
                                ? comment.userInfo.firstName.toString()
                                : ''
                            : '',
                        style: TextStyle(fontSize: 15),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 0, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          comment == null
                              ? comment.userInfo != null
                                  ? comment.userInfo.rate != null
                                      ? comment.userInfo.rate.toString()
                                      : '0'
                                  : '0'
                              : '0',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        StarRating(
                          rating: comment == null
                              ? comment.userInfo != null
                                  ? double.tryParse(
                                          comment.userInfo.rate.toString()) ??
                                      0.0
                                  : 0.0
                              : 0.0,
                          size: 15,
                          color: Color(0xffFAC917),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 0, right: 20, left: 10),
                      child: Text(
                        comment.comment != null
                            ? comment.comment.toString()
                            : '',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 15),
                        textAlign: TextAlign.right,
                      )),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 60.0,
                  height: 60.0,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: comment.userInfo != null
                        ? APIKeys.ONLINE_IMAGE_BASE_URL +
                            comment.userInfo.image.replaceAll('\\', '/')
                        : APIKeys.ONLINE_IMAGE_BASE_URL,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ImageLoad(60.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 1,
          color: Theme.of(context).secondaryHeaderColor,
        )
      ],
    )));
  }
}
