import 'package:flutter/material.dart';

import 'view/ortho_web.dart';

class FlutterOrtho {
  static Future create(
          {required BuildContext context,
          required Map<String, dynamic> orthoOptions}) async =>
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => OrthoWeb(orthoOptions: orthoOptions)));
}
