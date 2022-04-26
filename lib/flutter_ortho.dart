library flutter_ortho;

import 'package:flutter/material.dart';
import 'package:flutter_ortho/models/ortho_model.dart';
import 'package:flutter_ortho/view/ortho_web.dart';

export 'view/ortho_web.dart';
export 'models/ortho_model.dart';

class FlutterOrtho {
  static Future create(
          {required BuildContext context,
          required Map<String, dynamic> orthoOptions}) async =>
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => OrthoWeb(orthoOptions: orthoOptions)));
}
