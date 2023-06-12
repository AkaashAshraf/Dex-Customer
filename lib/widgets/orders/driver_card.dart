import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/driver_info.dart';
import 'package:customers/pages/orders/chat.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverCard extends StatefulWidget {
  final DriverInfo driver;
  final DeliveryHistory order;
  const DriverCard({Key key, this.driver, this.order}) : super(key: key);

  @override
  _DriverCardState createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CachedNetworkImage(
              height: 70,
              width: 70,
              imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                  widget.driver.image.toString(),
              placeholder: (context, url) => Center(child: ImageLoad(50.0)),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/dex.png'),
              fit: BoxFit.contain,
            ),
            SizedBoxResponsive(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextResponsive(widget.driver.firstName.toString(),
                    style: TextStyle(fontSize: 23, color: Colors.black)),
                SizedBoxResponsive(height: 10),
                TextResponsive(widget.driver.loginPhone.toString(),
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]))
              ],
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Chat(
                        to: 'driver',
                        from: '',
                        status: widget.order.state.toString(),
                        orderId: widget.order.id.toString(),
                        targetId: widget.driver.id.toString(),
                        targetName: widget.driver.firstName.toString(),
                        targetImage: widget.driver.image.toString(),
                      )));
            },
            icon: Icon(Icons.chat)),
        IconButton(
            onPressed: () async {
              final Uri _phoneUri =
                  Uri(scheme: "tel", path: widget.driver.loginPhone.toString());
              if (await canLaunch(_phoneUri.toString())) {
                launch(_phoneUri.toString());
              }
            },
            icon: Icon(Icons.phone))
      ],
    );
  }
}
