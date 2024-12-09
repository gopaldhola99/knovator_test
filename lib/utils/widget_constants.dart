
import 'package:fluttertoast/fluttertoast.dart';

///
/// Error Toast
errorToast({required String content}) {
  return Fluttertoast.showToast(msg: content);
}
