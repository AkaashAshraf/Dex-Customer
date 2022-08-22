import 'package:customers/providers/orders/rate_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RatePage extends StatefulWidget {
  final orderID;

  const RatePage({Key key, this.orderID}) : super(key: key);
  @override
  _RateState createState() => _RateState();
}

TextEditingController comment = TextEditingController();

class _RateState extends State<RatePage> {
  double rateProduct = 0;
  double rateShop = 0;
  double rateDriver = 0;
  @override
  void initState() {
    super.initState();
  }

  Widget shopCard() {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.white,
            offset: Offset.fromDirection(1),
            blurRadius: 50.0,
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Text(
              "قيم المطعم",
              style: TextStyle(fontSize: 18),
            ),
            StarRating(
              rating: rateShop,
              size: 40,
              starCount: 5,
              borderColor: Theme.of(context).accentColor,
              color: Theme.of(context).secondaryHeaderColor,
              onRatingChanged: (rate) {
                setState(() {
                  rateShop = rate;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCard() {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.white,
            offset: Offset.fromDirection(1),
            blurRadius: 50.0,
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Text(
              "قيم الخدمة",
              style: TextStyle(fontSize: 18),
            ),
            StarRating(
              rating: rateProduct,
              size: 40,
              starCount: 5,
              borderColor: Theme.of(context).accentColor,
              color: Theme.of(context).secondaryHeaderColor,
              onRatingChanged: (rate) {
                setState(() {
                  rateProduct = rate;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget driverCard() {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.white,
            offset: Offset.fromDirection(1),
            blurRadius: 50.0,
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Text(
              "قيم السائق",
              style: TextStyle(fontSize: 18),
            ),
            StarRating(
              rating: rateDriver,
              size: 40,
              starCount: 5,
              borderColor: Theme.of(context).accentColor,
              color: Theme.of(context).secondaryHeaderColor,
              onRatingChanged: (rate) {
                setState(() {
                  rateDriver = rate;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RateProvider>(builder: (context, rate, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("قيم"),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              shopCard(),
              SizedBox(
                height: 20,
              ),
              driverCard(),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: "‫هنا‬ ‫تعليقك‬ ‫أضف‬",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: comment,
                validator: (val) {
                  if (val.length == 0) {
                    return "Email cannot be empty";
                  } else {
                    return null;
                  }
                },
                style: new TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 20,
              ),
              serviceCard(),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await Provider.of<RateProvider>(context, listen: false).rate(
                    context: context,
                    delivery: widget.orderID,
                    driver: rateDriver,
                    shop: rateShop,
                    product: rateProduct,
                    comment: comment.text ?? "",
                  );
                  if (rate.rated) {
                    Navigator.of(context).pop();
                  }
                },
                child: ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black),
                    color: rate.loading
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: rate.loading
                        ? Center(child: CupertinoActivityIndicator())
                        : TextResponsive(
                            'تقييم',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
