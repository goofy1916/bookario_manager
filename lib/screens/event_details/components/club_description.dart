import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/description_text.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'all_prices.dart';

class EventDescription extends StatelessWidget {
  const EventDescription({
    Key? key,
    required this.event,
    required this.viewModel,
  }) : super(key: key);

  final EventModel event;
  final EventDetailsViewModel viewModel;

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
              .copyWith(fontWeight: FontWeight.bold, color: kSecondaryColor),
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
                    "Where : " + event.completeLocation + "\n" + event.location,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SpacingWidget(),
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/clock.svg",
              height: getProportionateScreenWidth(14),
            ),
            TextRow(
                text1: " What time",
                text2: " : ${getTimeOfEvent(event.dateTime)}")
          ],
        ),
        const SpacingWidget(),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: getProportionateScreenWidth(14),
              color: Colors.white,
            ),
            TextRow(
                text1: " On date ",
                text2: ": ${getDateOfEvent(event.dateTime)}"),
          ],
        ),
        const SpacingWidget(),
        const Text(
          "About the event",
          style: TextStyle(fontSize: 18, color: kSecondaryColor),
        ),
        DescriptionTextWidget(text: event.desc),
        const SpacingWidget(),
        TextRow(
            text1: "Promoters ",
            text2: ": ${viewModel.event.promoters?.length}"),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                viewModel.event.promoters?.length ?? 0,
                (index) => Column(
                  children: [
                    Text(
                      viewModel.event.promoters?[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    divider()
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: MaterialButton(
            color: Colors.grey[800],
            onPressed: () {
              viewModel.getPromoters();
            },
            child: const Text(
              "Add Promoters",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
        const SpacingWidget(),
        TextRow(
            text1: "Booked Passes ",
            text2: ": ${viewModel.event.bookedPasses?.length}"),
        Text(
          "Male: ${viewModel.event.totalMale}, Female: ${viewModel.event.totalFemale}, Tables: ${viewModel.event.totalTable}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SpacingWidget(),
        const Text(
          "Available Passes :",
          style: TextStyle(
            fontSize: 18,
            color: kSecondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        AllPrices(
          event: event,
          viewModel: viewModel,
        ),
        const SizedBox(height: 20),
        Center(
          child: MaterialButton(
            color: Colors.grey[800],
            onPressed: () {
              viewModel.createPasses();
            },
            child: const Text(
              "Add Passes",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
        const SpacingWidget(),
        if (viewModel.addNewCoupon)
          CouponForm(viewModel: viewModel)
        else
          SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Coupons for this event :",
                  style: TextStyle(
                    fontSize: 18,
                    color: kSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!viewModel.busy("coupons") &&
                    viewModel.couponsForEvent.isNotEmpty) ...[
                  Column(
                    children: viewModel.couponsForEvent
                        .map(
                          (coupon) => Card(
                            color: kSecondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: getCouponDetails(coupon),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: MaterialButton(
                    color: Colors.grey[800],
                    onPressed: () {
                      viewModel.newCoupon();
                    },
                    child: const Text(
                      "Add coupon",
                      style: TextStyle(color: Colors.white70),
                    ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
        ),
        InkWell(
            onTap: () => viewModel.removeCoupon(coupon),
            child: const Icon(Icons.remove_circle, color: kPrimaryLightColor)),
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
