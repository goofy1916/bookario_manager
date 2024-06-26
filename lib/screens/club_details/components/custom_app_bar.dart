import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String location;
  final String clubId;

  const CustomAppBar(
      {required this.clubId,
      required this.title,
      required this.location,
      Key? key})
      : super(key: key);

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFF141414),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            ActionButton(
              icon: "assets/icons/Back Icon.svg",
              press: Navigator.of(context).pop,
            ),
            const Spacer(),
            TitleAndLocation(title: title, location: location),
            const Spacer(),
            // ActionButton(
            //   icon: "assets/icons/edit.svg",
            //   press: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => EditClubDetails(clubId: clubId)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class TitleAndLocation extends StatelessWidget {
  const TitleAndLocation({
    Key? key,
    required this.title,
    required this.location,
  }) : super(key: key);

  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          location,
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final String icon;
  final GestureTapCallback press;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      focusColor: Colors.white12,
      onTap: press,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: SvgPicture.asset(
          icon,
          height: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
