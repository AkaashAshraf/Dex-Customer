import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class RulesPage extends StatefulWidget {
  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  @override
  Widget build(BuildContext context) {
    var string = "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة" +
        "لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص" +
        "لأو العديد من النصوص الاخري إضافة الى زيادة عدد الحروف التي يولدها التطبيق" +
        "إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص";

    String txt = Localizations.localeOf(context).languageCode == 'en' ? appInfo.privacyPolicyEn: appInfo.privacyPolicy;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  CommonAppBar(backButton: true, title: 'termsUse'.tr()),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Image.asset(
                    'assets/images/Dex.png',
                    width: 100,
                    height: 90,
                    fit: BoxFit.contain,
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Html(
                    data: """$txt""",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
