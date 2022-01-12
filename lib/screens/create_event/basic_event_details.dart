import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/custom_number_field.dart';
import 'package:bookario_manager/components/custom_text_form_field.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'add_event_viewmodel.dart';

Column basicEventDetails(AddEventViewModel viewModel, BuildContext context) {
  return Column(
    children: <Widget>[
      SingleChildScrollView(
        child: viewModel.isBusy
            ? const Loading()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context, viewModel);
                      },
                      child: viewModel.hasCoverPhoto
                          ? Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(color: Colors.white)),
                                  child: viewModel.createOrEdit ==
                                          CreateOrEdit.create
                                      ? Image.file(
                                          viewModel.coverPhoto!,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : Image.network(
                                          viewModel.event!.eventThumbnail,
                                          fit: BoxFit.fitHeight,
                                        ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      onTap: () => viewModel.removeThumbnail(),
                                      child: Container(
                                          padding: const EdgeInsets.all(4),
                                          height: 32,
                                          color: kSecondaryColor,
                                          child: const Center(
                                              child: Text("Remove"))),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              width: SizeConfig.screenWidth * 0.75,
                              height: 150,
                              child:
                                  const Center(child: Text('Add cover Photo')),
                            ),
                    ),
                  ),
                  CustomTextFormField(
                      fieldTitle: "Event Name",
                      fieldController: viewModel.eventNameTextController,
                      fieldHint: "Enter event name"),
                  CustomTextFormField(
                      fieldTitle: "Description",
                      fieldController: viewModel.eventDescriptionTextController,
                      fieldHint: "Enter description for the event"),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DateTimePicker(
                      style: const TextStyle(color: Colors.white70),
                      controller: viewModel.dateTimeTextController,
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      firstDate: viewModel.createOrEdit == CreateOrEdit.create
                          ? DateTime.now()
                          : DateTime.fromMicrosecondsSinceEpoch(
                              viewModel.event!.dateTime.microsecondsSinceEpoch),
                      lastDate: DateTime(2100),
                      icon: const Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      validator: (val) {
                        if (val != null &&
                            DateTime.tryParse(val)!.isBefore(DateTime.now())) {
                          return "Choose valid Date and Time";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  // CustomTextFormField(
                  //     fieldTitle: "Event location",
                  //     fieldController: viewModel.eventFullAddressController,
                  //     fieldHint: "Enter full address"),
                  CustomNumberFormField(
                      fieldTitle: "Total Capacity",
                      fieldController: viewModel.totalCapacityTextController,
                      fieldHint: "Enter total capacity for the event"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Crowd Distribution",
                          style: TextStyle(color: kSecondaryColor),
                        ),
                        Row(
                          children: [
                            const Text("Auto"),
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              child: Switch(
                                inactiveThumbColor: Colors.grey,
                                activeColor: kSecondaryColor,
                                onChanged: (bool value) {
                                  viewModel.updateShowRatio();
                                },
                                value: viewModel.showRatio,
                              ),
                            ),
                            const Text("Ratio Based")
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.showRatio)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('M/F Ratio:  '),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 3),
                              child: CustomNumberFormField(
                                  fieldTitle: "Male Ratio",
                                  fieldController:
                                      viewModel.maleRatioTextController,
                                  fieldHint: "eg. 3"),
                            ),
                          ),
                          const Text(' : '),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 3),
                              child: CustomNumberFormField(
                                  fieldTitle: "Female Ratio",
                                  fieldController:
                                      viewModel.femaleRatioTextController,
                                  fieldHint: "eg. 2"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  CustomNumberFormField(
                      fieldTitle: "Tables Count",
                      fieldController: viewModel.tableCountTextController,
                      fieldHint: "Total table Count"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: viewModel.createOrEdit == CreateOrEdit.create
                        ? DefaultButton(
                            text: "Create",
                            press: () {
                              viewModel.createEvent();
                            },
                          )
                        : DefaultButton(
                            text: "Update",
                            press: () {
                              viewModel.updateEvent();
                            },
                          ),
                  )
                ],
              ),
      ),
    ],
  );
}

void _showPicker(BuildContext context, AddEventViewModel viewModel) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Select from Gallery'),
                  onTap: () {
                    viewModel.imgFromGallery();
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      });
}
