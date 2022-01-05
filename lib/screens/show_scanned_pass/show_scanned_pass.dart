import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/rich_text_row.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/event_pass_model.dart';
import 'package:bookario_manager/screens/show_scanned_pass/show_scanned_pass_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ShowScannedPass extends StatelessWidget {
  const ShowScannedPass({Key? key, required this.passId, required this.eventId})
      : super(key: key);

  final String passId;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShowScannedPassViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getBookingData(passId, eventId),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Pass Details"),
            ),
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(5)),
                    if (viewModel.isBusy)
                      const Loading()
                    else if (viewModel.hasError)
                      const Text("Invalid Pass")
                    else if (viewModel.eventPass != null)
                      eventPassDetails(viewModel.eventPass!, context, viewModel)
                    else
                      const Text("No pass found!"),
                  ],
                ),
              ),
            ),
            floatingActionButton: viewModel.isBusy || viewModel.hasError
                ? const SizedBox.shrink()
                : viewModel.eventPass!.checked
                    ? const SizedBox.shrink()
                    : FloatingActionButton(
                        backgroundColor: kSecondaryColor,
                        onPressed: () {
                          viewModel.markPassChecked(passId);
                        },
                        child: const Icon(Icons.check),
                      ),
          ),
        );
      },
      viewModelBuilder: () => ShowScannedPassViewModel(),
    );
  }

  ClipRRect eventPassDetails(EventPass eventPass, BuildContext context,
      ShowScannedPassViewModel viewModel) {
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
                      ...passesList(eventPass, context),
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
                              textRight: eventPass.promoterId ?? "N/A",
                            ),
                            RichTextRow(
                              textLeft: "Event Name: ",
                              textRight: eventPass.eventName,
                            ),
                            RichTextRow(
                              textLeft: "Booked on: ",
                              textRight:
                                  eventPass.timeStamp.toDate().toString(),
                            ),
                            RichTextRow(
                              textLeft: "Paid: ₹",
                              textRight: eventPass.total.toString(),
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Checked: ",
                                  style: TextStyle(color: Colors.black),
                                ),
                                eventPass.checked
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : const Icon(Icons.cancel,
                                        color: Colors.red)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> passesList(EventPass eventPass, BuildContext context) {
    return List.generate(eventPass.passes!.length, (innerIndex) {
      final Passes currentPass = eventPass.passes![innerIndex];
      return getPassDetails(
        context,
        currentPass,
      );
    });
  }

  Column passTitle(EventPass eventPass, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        entryTypeAndName(
            eventPass.passes!.length, eventPass.eventName, context),
        RichTextRow(
          textLeft: "Booked on:  ",
          textRight: eventPass.timeStamp.toDate().toString(),
        ),
        RichTextRow(
          textLeft: "Paid:  ",
          textRight: eventPass.total.toString(),
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
      int noOfPass, String eventName, BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "No of passes: $noOfPass\nBooked for:  $eventName",
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: getProportionateScreenWidth(17),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
      ),
    );
  }
}
