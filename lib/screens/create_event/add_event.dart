import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_event_viewmodel.dart';
import 'basic_event_details.dart';

class AddEvent extends StatelessWidget {
  const AddEvent({
    Key? key,
    required this.club,
    this.createOrEdit,
    this.event,
  }) : super(key: key);

  final ClubDetails club;
  final CreateOrEdit? createOrEdit;
  final EventModel? event;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddEventViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.setClub(club, createOrEdit, event),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: viewModel.createOrEdit == CreateOrEdit.create
                ? const Text('Add New Event')
                : const Text('Update Event'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => confirmDiscard(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     IconButton(
                  //         onPressed: () {
                  //           if (viewModel.currentIndex > 0) {
                  //             viewModel.setIndex(viewModel.currentIndex - 1);
                  //           }
                  //         },
                  //         icon: const Icon(
                  //           Icons.arrow_back_ios,
                  //           color: kPrimaryColor,
                  //           size: 12,
                  //         )),
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: DotStepper(
                  //         // direction: Axis.vertical,
                  //         dotCount: 2,
                  //         dotRadius: 6,

                  //         /// THIS MUST BE SET. SEE HOW IT IS CHANGED IN NEXT/PREVIOUS BUTTONS AND JUMP BUTTONS.
                  //         activeStep: viewModel.currentIndex,
                  //         shape: Shape.circle,
                  //         spacing: 10,
                  //         indicator: Indicator.shift,

                  //         /// TAPPING WILL NOT FUNCTION PROPERLY WITHOUT THIS PIECE OF CODE.
                  //         onDotTapped: (tappedDotIndex) {
                  //           viewModel.setIndex(tappedDotIndex);
                  //         },

                  //         // DOT-STEPPER DECORATIONS
                  //         fixedDotDecoration: const FixedDotDecoration(
                  //           color: kPrimaryColor,
                  //         ),

                  //         indicatorDecoration: const IndicatorDecoration(
                  //           // style: PaintingStyle.stroke,
                  //           // strokeWidth: 8,
                  //           color: kSecondaryColor,
                  //         ),
                  //         lineConnectorDecoration:
                  //             const LineConnectorDecoration(
                  //           color: Colors.red,
                  //           strokeWidth: 0,
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //         onPressed: () {
                  //           if (viewModel.currentIndex < 2) {
                  //             viewModel.setIndex(viewModel.currentIndex + 1);
                  //           }
                  //         },
                  //         icon: const Icon(
                  //           Icons.arrow_forward_ios,
                  //           color: kPrimaryColor,
                  //           size: 12,
                  //         )),
                  //   ],
                  // ),
                  Form(
                      key: viewModel.formKey,
                      child: basicEventDetails(viewModel, context)),
                ],
              ),
            )),
          ),
        );
      },
      viewModelBuilder: () => AddEventViewModel(),
    );
  }
}

Future confirmDiscard(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        title: Text(
          "All added details will get discarded. Do you still want to go back?",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: 17, color: Colors.white),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            splashColor: Colors.red[50],
            child: Text(
              "No",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: kSecondaryColor),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
            splashColor: Colors.red[50],
            child: Text(
              "Yes",
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
