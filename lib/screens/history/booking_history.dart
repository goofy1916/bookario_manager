import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/rich_text_row.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/event_pass_model.dart';
import 'package:bookario_manager/screens/history/booking_history_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({Key? key, required this.eventId}) : super(key: key);

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingHistoryViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getBookingData(eventId),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Booking History"),
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: viewModel.isBusy
                      ? const Loading()
                      : viewModel.eventPasses.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenHeight(5)),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              viewModel.toggleToCheckedIn(),
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: viewModel.passType ==
                                                      PassType.checkedIn
                                                  ? kSecondaryColor
                                                  : Colors.black,
                                            ),
                                            child: Center(
                                                child: Text(
                                                    "Checked In (${viewModel.checkedInPasses.length})")),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              viewModel.toggleToRemaining(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: viewModel.passType ==
                                                      PassType.checkedIn
                                                  ? Colors.black
                                                  : kSecondaryColor,
                                            ),
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                  "Remaining (${viewModel.remainingPasses.length})"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Column(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ...List.generate(
                                            viewModel.passType ==
                                                    PassType.checkedIn
                                                ? viewModel
                                                    .checkedInPasses.length
                                                : viewModel
                                                    .remainingPasses.length,
                                            (index) {
                                              EventPass currentEventPass =
                                                  viewModel.passType ==
                                                          PassType.checkedIn
                                                      ? viewModel
                                                              .checkedInPasses[
                                                          index]
                                                      : viewModel
                                                              .remainingPasses[
                                                          index];
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 6),
                                                child: AnimatedCrossFade(
                                                  crossFadeState: viewModel
                                                          .isExpanded[index]
                                                      ? CrossFadeState
                                                          .showSecond
                                                      : CrossFadeState
                                                          .showFirst,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  firstChild: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Stack(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        5),
                                                                color: const Color(
                                                                        0xFFd6d6d6)
                                                                    .withOpacity(
                                                                        0.8),
                                                                child: passTitle(
                                                                    currentEventPass,
                                                                    context),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              viewModel.isExpanded[
                                                                      index]
                                                                  ? viewModel.isExpanded[
                                                                          index] =
                                                                      false
                                                                  : viewModel
                                                                          .isExpanded[
                                                                      index] = true;
                                                              viewModel
                                                                  .notifyListeners();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          5.0),
                                                              child: Icon(
                                                                viewModel.isExpanded[
                                                                        index]
                                                                    ? Icons
                                                                        .arrow_drop_up
                                                                    : Icons
                                                                        .arrow_drop_down,
                                                                size: 30,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  secondChild: eventPassDetails(
                                                      currentEventPass,
                                                      context,
                                                      viewModel,
                                                      index),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      20)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Your bookings will be available here\nwhen you book an event.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => BookingHistoryViewModel(),
    );
  }

  ClipRRect eventPassDetails(EventPass currentEventPass, BuildContext context,
      BookingHistoryViewModel viewModel, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: const Color(0xFFd6d6d6).withOpacity(0.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...passesList(currentEventPass, context),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichTextRow(
                              textLeft: "PromoterID: ",
                              textRight: currentEventPass.promoterId ?? "N/A",
                            ),
                            RichTextRow(
                              textLeft: "Booked on: ",
                              textRight: currentEventPass.timeStamp
                                  .toDate()
                                  .toString(),
                            ),
                            RichTextRow(
                              textLeft: "Paid: ₹",
                              textRight: currentEventPass.total.toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                viewModel.updateIsExpanded(index);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  viewModel.isExpanded[index]
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  size: 30,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> passesList(EventPass currentEventPass, BuildContext context) {
    return List.generate(currentEventPass.passes!.length, (innerIndex) {
      final Passes currentPass = currentEventPass.passes![innerIndex];
      return getPassDetails(
        context,
        currentPass,
      );
    });
  }

  Column passTitle(EventPass currentEventPass, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        entryTypeAndName(
            currentEventPass.passes!.length,
            currentEventPass.passes!.first.name ??
                currentEventPass.passes!.first.femaleName!,
            context),
        RichTextRow(
          textLeft: "Booked on:  ",
          textRight: currentEventPass.timeStamp.toDate().toString(),
        ),
        RichTextRow(
          textLeft: "Paid:  ",
          textRight: currentEventPass.total.toString(),
        )
      ],
    );
  }

  Container getPassDetails(BuildContext context, Passes pass) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Entry Type: ${pass.entryType!}",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: getProportionateScreenWidth(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          if (pass.entryType != 'Couple Entry')
            Row(
              children: [
                Text(
                  pass.name!,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                Text(
                  ', ${pass.gender!}, ${pass.age!}',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: getProportionateScreenWidth(13),
                        color: Colors.black,
                      ),
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      pass.femaleName!,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      ', ${pass.femaleGender!}',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(13),
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      ', ${pass.femaleAge!}',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(13),
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      pass.maleName!,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      ', ${pass.maleGender!}',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(13),
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      ', ${pass.maleAge!}',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(13),
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Pass Type: ${pass.passType ?? "Regular"}",
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: getProportionateScreenWidth(13),
                    color: Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  RichText entryTypeAndName(
      int noOfPass, String bookedBy, BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "No of passes: $noOfPass\nBooked By: $bookedBy",
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: getProportionateScreenWidth(17),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
    );
  }
}
