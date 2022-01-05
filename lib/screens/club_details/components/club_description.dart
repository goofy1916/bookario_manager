import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../components/size_config.dart';
import '../../../components/description_text.dart';

class ClubDescription extends StatefulWidget {
  const ClubDescription({
    Key? key,
    required this.club,
    this.pressOnSeeMore,
  }) : super(key: key);

  final ClubDetails club;
  final GestureTapCallback? pressOnSeeMore;

  @override
  _ClubDescriptionState createState() => _ClubDescriptionState();
}

class _ClubDescriptionState extends State<ClubDescription> {
  bool addingPromoter = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: getProportionateScreenWidth(10),
            ),
            child: const Text(
              "About us",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          DescriptionTextWidget(text: widget.club.desc!),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Location point.svg",
                      height: getProportionateScreenWidth(15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: SelectableText(
                          widget.club.address!,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  addPromoterPopUp(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[300]),
                        child: SvgPicture.asset(
                          "assets/icons/add-user.svg",
                          height: 20,
                        ),
                      ),
                      const Text(
                        "Add\nPromoter",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white54),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future addPromoterPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return addingPromoter
            ? const Loading()
            : AlertDialog(
                backgroundColor: Colors.grey[900],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                title: Text(
                  "Enter promoter's ID:",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 17, color: Colors.white),
                ),
                content: promoterEmailFormField(),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      if (promoterId.text.isNotEmpty) {
                        setState(() {
                          addingPromoter = true;
                        });
                        // await locator<FirebaseService>()
                        //     .addPromoter(promoterId.text);
                      }
                    },
                    splashColor: Colors.red[50],
                    child: Text(
                      "Add",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: kSecondaryColor),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Future promoterError(BuildContext context, String errorMessage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          title: Text(
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: Colors.white54),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              splashColor: Colors.red[50],
              child: Text(
                "Ok",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future promoterCreated(BuildContext context, String promoterId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          title: Text(
            "Promoter Created successfully.",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 17,
                  color: Colors.white,
                ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Promoter's ID:",
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
              ),
              Container(
                width: SizeConfig.screenWidth,
                color: Colors.black12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      promoterId,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                await FlutterClipboard.copy(promoterId);
                Navigator.pop(context);
              },
              splashColor: Colors.red[50],
              child: Text(
                "Copy",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  final promoterId = TextEditingController();

  TextFormField promoterEmailFormField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.done,
      controller: promoterId,
      decoration: const InputDecoration(
        labelText: "Promoter ID",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
