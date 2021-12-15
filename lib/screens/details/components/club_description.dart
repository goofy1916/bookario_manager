import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/details/details_screen_viewmodel.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'all_prices.dart';
import 'description_text.dart';

class EventDescription extends StatelessWidget {
  const EventDescription({
    Key? key,
    required this.event,
    required this.viewModel,
  }) : super(key: key);

  final EventModel event;
  final DetailsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(5),
          ),
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
                    event.location,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/clock.svg",
              height: getProportionateScreenWidth(14),
            ),
            Text(
              ' ${getTimeOfEvent(event.dateTime)}',
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 25,
          ),
          child: Text(
            "About the event",
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ),
        DescriptionTextWidget(text: event.desc),
        const Padding(
          padding: EdgeInsets.only(
            top: 25,
          ),
          child: Text(
            "Available Passes:",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AllPrices(event: event),
        const SizedBox(height: 20),
        const Divider(
          color: Colors.white,
        ),
        if (viewModel.addNewCoupon)
          CouponForm(viewModel: viewModel)
        else
          SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                if (!viewModel.busy("coupons") &&
                    viewModel.couponsForEvent.isNotEmpty) ...[
                  whiteTextField("Coupons for this event:"),
                  Column(
                    children: viewModel.couponsForEvent
                        .map(
                          (coupon) => ListTile(
                            title: Card(
                              color: kSecondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: getCouponDetails(coupon),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                MaterialButton(
                  color: Colors.grey[800],
                  onPressed: () {
                    viewModel.newCoupon();
                  },
                  child: const Text(
                    "Add coupon",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  whiteTextField18(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontSize: 18));
  }

  whiteTextField(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontSize: 12));
  }

  getCouponDetails(CouponModel coupon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (coupon.percentOff != null) ...[
          whiteTextField18("Coupon type: Percent"),
          whiteTextField(
              "Percent off: ${coupon.percentOff}%, Max discount: Rs.${coupon.maxAmount},"),
          whiteTextField(
              "Min amount required: Rs.${coupon.minAmountRequired}, Max coupons: ${coupon.maxCoupons}"),
          whiteTextField("Remaining coupons: ${coupon.remainingCoupons}"),
        ] else ...[
          whiteTextField18("Coupon type: Flat off"),
          whiteTextField("Max discount: Rs.${coupon.maxAmount},"),
          whiteTextField(
              "Min amount required: Rs.${coupon.minAmountRequired}, Max coupons: ${coupon.maxCoupons}"),
          whiteTextField("Remaining coupons: ${coupon.remainingCoupons}"),
        ]
      ],
    );
  }
}

class CouponForm extends StatelessWidget {
  const CouponForm({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DetailsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Type : ",
                style: viewModel.textStyle.copyWith(color: kSecondaryColor)),
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
