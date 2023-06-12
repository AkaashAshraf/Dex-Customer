import 'package:customers/models/categories/categories.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final bool selecetd;
  CategoryCard({this.category, this.selecetd});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ContainerResponsive(
          width: 200,
          height: 60,
          margin: EdgeInsetsResponsive.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: widget.selecetd ? Colors.black : Colors.black),
            borderRadius: BorderRadius.circular(15),
            color: widget.selecetd ? Colors.white : Colors.black,
          ),
          child: Center(
            child: TextResponsive(
                context.locale == Locale('en')
                    ? widget.category.name.toString()
                    : widget.category.slug.toString(),
                style: TextStyle(
                    fontSize: 25,
                    color: widget.selecetd ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
