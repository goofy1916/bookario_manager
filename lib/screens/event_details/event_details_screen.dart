import 'package:bookario_manager/components/hovering_back_button.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/event_details/components/club_description.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EventDetailsView extends StatelessWidget {
  final EventModel event;

  const EventDetailsView({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventDetailsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.updateEvent(event),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: const HoveringBackButton(),
              title: const Text(
                "Event",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () => viewModel.goToQrCodeScanner(),
                  child: const Icon(Icons.qr_code_scanner),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: event.id!,
                        child: Image.network(
                          event.eventThumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: getProportionateScreenWidth(10)),
                    padding: EdgeInsets.only(
                      top: getProportionateScreenWidth(15),
                      left: getProportionateScreenWidth(20),
                      right: getProportionateScreenWidth(20),
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          // !Show club name
                          event.name,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                        Text(
                          '(${event.location})',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(12),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        EventDescription(
                          event: event,
                          viewModel: viewModel,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        // TODO: Display remaining stags here
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => EventDetailsViewModel(),
    );
  }
}
