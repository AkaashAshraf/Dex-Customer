import 'package:customers/models/general/app_info.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
/////////vars/////////
  bool loading;
  AppInfo appInfo;
  String url = 'http://80.211.24.15/api/';
/////functions//////

  _loading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Center(
          child: SpinKitCubeGrid(
            color: Color(0xff09C215),
            // color: Color(0xff512b59),
            size: 50,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text('loading'.tr())
      ],
    );
  }

  Future getAppInfo() async {
    try {
      var response = await Dio().get(url + 'AppInfo/1');
      var data = response.data;
      print(data);

      appInfo = AppInfo.fromJson(data);
      String txt = appInfo.privacyPolicy;
      setState(() {
        loading = false;
        txt1 = txt;
      });
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getAppInfo();
  }

  var txt1;
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    var string = "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة" +
        "لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص" +
        "لأو العديد من النصوص الاخري إضافة الى زيادة عدد الحروف التي يولدها التطبيق" +
        "إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص";

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ContainerResponsive(
          height: 1560,
          width: 720,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          )),
          child: ListView(
            children: <Widget>[
              SizedBoxResponsive(
                height: 70,
              ),
              SizedBoxResponsive(
                height: 50,
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      TextResponsive(
                        'termsUse',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ).tr(),
                    ],
                  ),
                ),
              ),
              SizedBoxResponsive(
                height: 40,
              ),
              Center(
                child: ContainerResponsive(
                    height: 150,
                    width: 300,
                    child: Image.asset(
                      'images/wellcome.png',
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBoxResponsive(
                height: 50,
              ),
              Center(
                child: loading ? _loading() : Html(data: """$txt1"""),
              )
            ],
          ),
        ),
      ),
    );
  }
}
