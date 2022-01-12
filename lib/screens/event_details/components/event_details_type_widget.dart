import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/custom_number_field.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/coupon_model.dart';
import 'package:bookario_manager/screens/event_details/components/all_prices.dart';
import 'package:bookario_manager/screens/event_details/components/club_description.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';

class EventDetailsTypeWidget extends StatelessWidget {
  const EventDetailsTypeWidget({Key? key, required this.viewModel})
      : super(key: key);

  final EventDetailsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    switch (viewModel.selectedEventDetailsType) {
      case EventDetailsType.passes:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextRow(
                            text1: "Booked Passes ",
                            text2: ": ${viewModel.event.bookedPasses?.length}"),
                        Center(
                          child: TextButton(
                            onPressed: () => viewModel.checkAllPasses(),
                            child: const Text(
                              "Show all...",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Male: ${viewModel.event.totalMale}, Female: ${viewModel.event.totalFemale}, Tables: ${viewModel.event.totalTable}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: MaterialButton(
                        color: Colors.grey[800],
                        onPressed: () => showCrowdBalance(viewModel, context),
                        child: const Text(
                          "Add people",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Passe types :",
                      style: TextStyle(
                        fontSize: 18,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AllPrices(
                      event: viewModel.event,
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
                  ],
                ),
              ),
            )
          ],
        );
      case EventDetailsType.coupons:
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ]),
          ),
        );
      case EventDetailsType.promoters:
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextRow(
                  text1: "Promoters ",
                  text2: ": ${viewModel.event.promoters?.length}"),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Promoter Id",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(
                                "Pass Count",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                          color: kSecondaryColor,
                        )
                      ],
                    ),
                    ...List.generate(
                      viewModel.promoterDetails.length,
                      (index) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  viewModel.promoterDetails[index]['id'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  viewModel.promoterDetails[index]['passCount']
                                      .toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
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
            ]),
          ),
        );
    }
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

  whiteTextField18(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontSize: 18));
  }

  whiteTextField(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontSize: 12));
  }

  showCrowdBalance(EventDetailsViewModel viewModel, BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: Colors.black,
              title: const Text('Crowd Balance',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomNumberFormField(
                      fieldController: viewModel.maleCountController,
                      fieldTitle: "Add Male",
                      fieldHint: "eg: 2"),
                  CustomNumberFormField(
                      fieldController: viewModel.femaleCountController,
                      fieldTitle: "Add Female",
                      fieldHint: "eg: 1"),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 0.15,
                        right: SizeConfig.screenWidth * 0.15,
                        bottom: getProportionateScreenWidth(10),
                        top: getProportionateScreenWidth(2),
                      ),
                      child: DefaultButton(
                        text: "Add People",
                        press: () async {
                          viewModel.balanceCrowd();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
