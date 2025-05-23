import 'package:flutter/material.dart';

class SignupWithWidget extends StatelessWidget {
  final String btnFor;
  final IconData? icon;
  final Color btnColor;
  final String? imgPath;
  final Color? txtColor;
  final Function callBack;
  const SignupWithWidget(
      {super.key,
      required this.btnFor,
      this.icon,
      required this.btnColor,
      this.imgPath,
      this.txtColor,
      required this.callBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callBack(),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.72,
        height: 50,
        decoration: BoxDecoration(
          color: btnColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Icon(icon, color: Colors.white, size: 35)
                  : Image.asset(imgPath!, width: 30),
              SizedBox(width: 20),
              Text(
                "SIGN UP USING ${btnFor}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: txtColor != null ? txtColor : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
