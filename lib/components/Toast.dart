import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/configs/colors.dart';

showToast( String msg, bool error) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: error ? AppColors.secondary.withOpacity(0.5) : AppColors.green.withOpacity(0.5),
      textColor: AppColors.white,
      fontSize: 14,
      webPosition: 'center',
      webBgColor: '00000000');
}
