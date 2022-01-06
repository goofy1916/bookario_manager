import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/custom_number_field.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/components/hovering_back_button.dart';
import 'package:bookario_manager/components/size_config.dart';
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
      onModelReady: (viewModel) => viewModel.updateCoupons(event),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: const HoveringBackButton(),
            title: const Text(
              "Event",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
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
                        tag: event.id ?? "",
                        child: Image.network(
                          event.eventThumbnail,
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
                            event: event,
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
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: kSecondaryColor,
                  height: 80,
                  child: InkWell(
                    onTap: eventDisplayType == EventDisplayType.preview
                        ? () => viewModel.handleBack(true)
                        : () => viewModel.goToQrCodeScanner(viewModel),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            eventDisplayType == EventDisplayType.preview
                                ? "Create"
                                : "Scan",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
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
