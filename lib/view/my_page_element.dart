import 'package:flutter/material.dart';

class MyPageElement extends StatelessWidget {
  MyPageElement({required this.icon, required this.child, this.isLocation = false, this.onTap});

  final IconData icon;
  final Widget child;
  final bool isLocation;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 14),
        height: 50,
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Color(0xFF707070),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: child,
            ),
            if (!isLocation)
              Expanded(
                child: Text(
                  '>',
                  textAlign: TextAlign.end,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MyPageLocation extends StatelessWidget {
  MyPageLocation({required this.icon, required this.title, required this.location, this.titleColor = Colors.black, this.onTap});

  final IconData icon;
  final Color titleColor;
  final String title;
  final String location;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MyPageElement(
      icon: icon,
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Color(0xFF707070), fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: '$title ',
              style: TextStyle(color: titleColor),
            ),
            TextSpan(text: location),
          ],
        ),
      ),
      isLocation: true,
      onTap: onTap,
    );
  }
}

class MyPageButton extends StatelessWidget {
  MyPageButton({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MyPageElement(
      icon: icon,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
