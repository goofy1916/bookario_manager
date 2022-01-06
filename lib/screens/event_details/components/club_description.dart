import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/description_text.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/event_details/components/event_details_tab_bar.dart';
import 'package:bookario_manager/screens/event_details/components/event_details_type_widget.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'all_prices.dart';

Color bodyTextColor = Colors.white;

class EventDescription extends StatelessWidget {
  const EventDescription({
    Key? key,
    required this.event,
    required this.viewModel,
  }) : super(key: key);

  final EventModel event;
  final EventDetailsViewModel viewModel;

  Widget getTimeOfEvent(Timestamp dateTime) {
    final DateTime temp =
        DateTime.fromMicrosecondsSinceEpoch(dateTime.microsecondsSinceEpoch);
    return Text(
      "${temp.hour}:${temp.minute < 10 ? "0${temp.minute}" : temp.minute}",
      style: TextStyle(color: bodyTextColor, fontSize: 18),
    );
  }

  Widget getDateOfEvent(Timestamp dateTime) {
    final formatter = DateFormat("MMM");
    final DateTime date = dateTime.toDate();
    return Column(
      children: [
        Text(
          formatter.format(date),
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
        Text(
          date.day.toString(),
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kSecondaryColor,
                  ),
                  child: Center(
                    child: getDateOfEvent(event.dateTime),
                  ),
                ),
                getTimeOfEvent(event.dateTime),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                          height: 0.9,
                        ),
                  ),
                  SelectableText(
                    event.location,
                    maxLines: 1,
                    style: TextStyle(color: bodyTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Text(
          "About the event",
          style: TextStyle(fontSize: 18, color: kSecondaryColor),
        ),
        DescriptionTextWidget(text: event.desc),
        const SizedBox(
          height: 20,
        ),
        EventDetailsTabBar(
          viewModel: viewModel,
        ),
        const SizedBox(
          height: 20,
        ),
        EventDetailsTypeWidget(viewModel: viewModel)
      ],
    );
  }
}

class SpacingWidget extends StatelessWidget {
  const SpacingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        divider(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class CouponForm extends StatelessWidget {
  const CouponForm({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final EventDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Type : ",
                style: TextStyle(color: kSecondaryColor, fontSize: 14)),
            DropdownButton<String>(
              dropdownColor: Colors.grey,
              items: const [
                DropdownMenuItem(
                    child: Text(
                      "Percent",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    value: "Percent"),
                DropdownMenuItem(
                    child: Text("Flat off",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    value: "Flat off"),
              ],
              value: viewModel.couponType,
              onChanged: (value) => viewModel.updateCouponType(value!),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.couponType == "Percent")
          TextFormField(
            style: const TextStyle(color: Colors.white70),
            keyboardType: TextInputType.number,
            cursorColor: Colors.white70,
            textInputAction: TextInputAction.done,
            controller: viewModel.percentOff,
            decoration: const InputDecoration(
              labelText: "Percent",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        const SizedBox(height: 12),
        TextFormField(
          style: const TextStyle(color: Colors.white70),
          keyboardType: TextInputType.number,
          cursorColor: Colors.white70,
          textInputAction: TextInputAction.done,
          controller: viewModel.maxDiscount,
          decoration: const InputDecoration(
            labelText: "Max discount (in rupees)",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          style: const TextStyle(color: Colors.white70),
          keyboardType: TextInputType.number,
          cursorColor: Colors.white70,
          textInputAction: TextInputAction.done,
          controller: viewModel.maxCoupons,
          decoration: const InputDecoration(
            labelText: "Max coupons",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          style: const TextStyle(color: Colors.white70),
          keyboardType: TextInputType.number,
          cursorColor: Colors.white70,
          textInputAction: TextInputAction.done,
          controller: viewModel.minAmounRequired,
          decoration: const InputDecoration(
            labelText: "Min amount",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Cancel",
                press: () {
                  viewModel.cancelCoupon();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Add",
                press: () {
                  viewModel.addCoupon();
                },
              ),
            )
          ],
        )
      ],
    );
  }
}

class CouponCard extends StatelessWidget {
  const CouponCard({
    Key? key,
    required this.allCoupons,
    this.index,
  }) : super(key: key);

  final List allCoupons;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFd6d6d6).withOpacity(0.8),
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${allCoupons[index!]['couponAmount']}% OFF',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                allCoupons[index!]['couponName'].toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Coupon code:\n${allCoupons[index!]['couponCode']}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () async {
                await FlutterClipboard.copy(
                  '${allCoupons[index!]['couponAmount']}% OFF\n${allCoupons[index!]['couponName']}\nCoupon code: ${allCoupons[index!]['couponCode']}',
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.copy,
                  size: 22,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextRow extends StatelessWidget {
  const TextRow({Key? key, required this.text1, required this.text2})
      : super(key: key);

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text1,
            style: const TextStyle(color: kSecondaryColor, fontSize: 18)),
        Text(text2, style: const TextStyle(color: kPrimaryColor, fontSize: 18))
      ],
    );
  }
}
