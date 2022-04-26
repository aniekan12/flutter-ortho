// ignore_for_file: prefer_initializing_formals

class OrthoModel {
  String? data;
  bool? isSuccessful;
  bool? hasError;
  bool? isDone;
  bool? onClose;

  OrthoModel(bool isDone, bool isSuccessful, bool hasError, bool onClose,
      String data) {
    this.isDone = isDone;
    this.isSuccessful = isSuccessful;
    this.hasError = hasError;
    this.onClose = onClose;
    this.data = data;
  }
}
