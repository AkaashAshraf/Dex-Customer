import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class LogsticCard extends StatefulWidget {
  final DeliveryHistory order;
  const LogsticCard({Key key, this.order}) : super(key: key);

  @override
  _LogsticCardState createState() => _LogsticCardState();
}

class _LogsticCardState extends State<LogsticCard> {
  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
      margin: EdgeInsetsResponsive.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsetsResponsive.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: Theme.of(context).secondaryHeaderColor),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            CachedNetworkImage(
              imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                  widget.order.logsticTripImg.toString(),
              placeholder: (context, url) => ImageLoad(40.0),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/dex.png'),
              height: 70,
              width: 70,
              fit: BoxFit.contain,
            ),
            SizedBoxResponsive(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextResponsive(
                  '${widget.order.logsticTripFromCity} -- ${widget.order.logsticTripToCity}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBoxResponsive(
                  height: 20,
                ),
                TextResponsive(
                  context.locale == Locale('ar')
                      ? widget.order.logsticTripCarAr.toString()
                      : widget.order.logsticTripCar.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            TextResponsive(
              widget.order.logsticTripDate.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBoxResponsive(
              height: 20,
            ),
            TextResponsive(
              "orderNumber".tr() + ' : ' + widget.order.id.toString(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ])
        ],
      ),
    );
  }
}
