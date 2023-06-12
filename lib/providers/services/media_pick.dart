import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class MediaPickDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('chooseImage').tr(),
                const SizedBox(
                  height: 8,
                ),
                ListTile(
                  onTap: () async {
                    var file = await ImagePicker.pickImage(
                        source: ImageSource.camera, imageQuality: 50);
                    Navigator.pop(context, file);
                  },
                  title: Icon(
                    Icons.camera_alt,
                    color: Colors.greenAccent,
                  ),
                  trailing: Text('camera').tr(),
                ),
                ListTile(
                  onTap: () async {
                    var file = await ImagePicker.pickImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    Navigator.pop(context, file);
                  },
                  title: Icon(
                    Icons.image,
                    color: Colors.greenAccent,
                  ),
                  trailing: Text('media').tr(),
                ),
                FlatButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel').tr(),
                )
              ],
            ),
          )),
    );
  }
}
