import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LinkProvider extends ChangeNotifier {
  Uri _link;
  Uri get link => _link;

  String _shortLink;
  String get shortLink => _shortLink;

  Future<void> generateDynamicLink(
      {String title,
      String id,
      String name,
      String pic,
      String productName}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: "https://delieryx.page.link",
      link: Uri.parse(
          "https://delieryx.page.link/share/?product=$title&refrence=$id&name=$name"),
      androidParameters: AndroidParameters(
        packageName: "xzone.dex.customers",
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'xzone.dex.customers',
        minimumVersion: "0",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          imageUrl: Uri.parse(pic) ??
              Uri.parse(
                  'http://www.dexoman.com/storage/customers/gernral1623526456.png'),
          title: "DeliveryX Product",
          description: "$productName"),
    );
    _link = await parameters.buildUrl();
    print(_link.query);
    var apikey = 'AIzaSyAWZAXT4QKXiFnY9foIZYM_yNqC_kOG9Rc';
    var response = await http.post(
        Uri.parse(
            'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$apikey'),
        body: {
          "longDynamicLink": _link.toString(),
        });
    var shortLink = json.decode(response.body)['shortLink'];
    _shortLink = shortLink;
  }
}
