import 'dart:io';

import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

import 'add_event_viewmodel.dart';
import 'add_passes.dart';
import 'basic_event_details.dart';

class AddEvent extends StatelessWidget {
  const AddEvent({
    Key? key,
    required this.club,
  }) : super(key: key);

  final ClubDetails club;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddEventViewModel>.reactive(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add New Event'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (viewModel.currentIndex > 0) {
                              viewModel.setIndex(viewModel.currentIndex - 1);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: kPrimaryColor,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DotStepper(
                          // direction: Axis.vertical,
                          dotCount: 4,
                          dotRadius: 6,

                          /// THIS MUST BE SET. SEE HOW IT IS CHANGED IN NEXT/PREVIOUS BUTTONS AND JUMP BUTTONS.
                          activeStep: viewModel.currentIndex,
                          shape: Shape.circle,
                          spacing: 10,
                          indicator: Indicator.shift,

                          /// TAPPING WILL NOT FUNCTION PROPERLY WITHOUT THIS PIECE OF CODE.
                          onDotTapped: (tappedDotIndex) {
                            viewModel.setIndex(tappedDotIndex);
                          },

                          // DOT-STEPPER DECORATIONS
                          fixedDotDecoration: const FixedDotDecoration(
                            color: kPrimaryColor,
                          ),

                          indicatorDecoration: const IndicatorDecoration(
                            // style: PaintingStyle.stroke,
                            // strokeWidth: 8,
                            color: kSecondaryColor,
                          ),
                          lineConnectorDecoration:
                              const LineConnectorDecoration(
                            color: Colors.red,
                            strokeWidth: 0,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (viewModel.currentIndex < 3) {
                              viewModel.setIndex(viewModel.currentIndex + 1);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: kPrimaryColor,
                          )),
                    ],
                  ),
                  getChild(viewModel, context)
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

getChild(AddEventViewModel viewModel, BuildContext context) {
  List<Widget> widgets = [
    basicEventDetails(viewModel, context),
    addPasses(viewModel, context)
  ];
  return widgets[viewModel.currentIndex];
}

Future showErrors(BuildContext context, String text) {
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
          text,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: 17, color: Colors.white),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            splashColor: kSecondaryColor,
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

customNumberFormField(
  String fieldTitle,
  TextEditingController fieldController,
  String fieldHint,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.white70,
      // focusNode: viewModel.nameFocusNode,
      controller: fieldController,
      decoration: InputDecoration(
        labelText: fieldTitle,
        hintText: fieldHint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      // onFieldSubmitted: (value) {
      //   viewModel.nameFocusNode.unfocus();
      //   FocusScope.of(context).requestFocus(viewModel.phoneNumberFocusNode);
      // },
    ),
  );
}

customTextFormField(
  String fieldTitle,
  TextEditingController fieldController,
  String fieldHint,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.white70,
      // focusNode: viewModel.nameFocusNode,
      controller: fieldController,
      decoration: InputDecoration(
        labelText: fieldTitle,
        hintText: fieldHint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      // onFieldSubmitted: (value) {
      //   viewModel.nameFocusNode.unfocus();
      //   FocusScope.of(context).requestFocus(viewModel.phoneNumberFocusNode);
      // },
    ),
  );
}
