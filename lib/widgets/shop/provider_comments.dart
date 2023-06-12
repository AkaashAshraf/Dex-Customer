import 'package:customers/models/shops.dart';
import 'package:customers/widgets/shop/comment_card.dart';
import 'package:flutter/material.dart';

class ProviderComments extends StatelessWidget {
  final List<ShopsComments> comments;
  ProviderComments({this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => CommentCard(
        comment: comments[index],
      ),
      itemCount: comments.length,
    );
  }
}
