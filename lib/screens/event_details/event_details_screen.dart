import 'dart:io';

import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/components/hovering_back_button.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/event_details/components/club_description.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EventDetailsView extends StatelessWidget {
  final EventModel event;
  final EventDisplayType eventDisplayType;

  const EventDetailsView(
      {Key? key, required this.event, required this.eventDisplayType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventDetailsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.setEvent(event, eventDisplayType),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: const HoveringBackButton(),
            title: Text(
              eventDisplayType == EventDisplayType.preview
                  ? "Preview"
                  : "Event",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            actions: eventDisplayType == EventDisplayType.preview
                ? []
                : [
                    InkWell(
                      onTap: viewModel.event.premium
                          ? null
                          : () => viewModel.makeEventPremium(),
                      child: viewModel.event.premium
                          ? const Icon(
                              Icons.star,
                              color: kSecondaryColor,
                              size: 32,
                            )
                          : const Icon(
                              Icons.star_border,
                              color: kSecondaryColor,
                              size: 32,
                            ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
          ),
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height / 2 - 100,
                      child: Hero(
                        tag: viewModel.event.id ?? "",
                        child: Image.network(
                          viewModel.event.eventThumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(height: 50, color: Colors.black),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2 - 100,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          EventDescription(
                            event: viewModel.event,
                            viewModel: viewModel,
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: eventDisplayType == EventDisplayType.preview
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: eventDisplayType == EventDisplayType.preview
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                            backgroundColor: kSecondaryColor,
                            onPressed: () => viewModel.handleBack(true),
                            child: const Icon(Icons.check)),
                      )
                    : Container(
                        width: double.infinity,
                        color: kSecondaryColor,
                        height: Platform.isIOS ? 80 : 60,
                        child: InkWell(
                          onTap: () => viewModel.goToQrCodeScanner(viewModel),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Scan",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => EventDetailsViewModel(),
    );
  }
}
