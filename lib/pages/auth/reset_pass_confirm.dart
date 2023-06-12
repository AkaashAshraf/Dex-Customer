import 'package:flutter/material.dart';
// import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class ConfirmReset extends StatefulWidget {
  @override
  _ConfirmResetState createState() => _ConfirmResetState();
}

class _ConfirmResetState extends State<ConfirmReset> {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: TextResponsive('changePassword'.tr(),
              style: TextStyle(
                fontSize: 35,
              )),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ContainerResponsive(
                margin: EdgeInsetsResponsive.symmetric(horizontal: 150),
                child: PinInputTextField(
                  pinLength: 4,
                  decoration: BoxLooseDecoration(
                      strokeColorBuilder:
                          PinListenColorBuilder(Colors.black26, Colors.black26),
                      bgColorBuilder:
                          PinListenColorBuilder(Colors.black26, Colors.black26),
                      textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ),
            ),
            SizedBoxResponsive(height: 60),
            Center(
              child: ContainerResponsive(
                margin: EdgeInsetsResponsive.symmetric(horizontal: 150),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: TextResponsive(
                  'confirm'.tr(),
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
