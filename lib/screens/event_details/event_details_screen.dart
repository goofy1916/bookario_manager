import 'package:bookario_manager/components/custom_number_field.dart';
import 'package:bookario_manager/components/default_button.dart';
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
                  onTap: () => showCrowdBalance(viewModel, context),
                  child: const Center(
                    child: Icon(Icons.person_add_alt_1_rounded),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () => viewModel.checkAllPasses(),
                  child: const Center(
                    child: Icon(
                      Icons.list_alt_rounded,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
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
                        EventDescription(
                          event: event,
                          viewModel: viewModel,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => viewModel.goToQrCodeScanner(viewModel),
              child: const Icon(Icons.qr_code_scanner),
            ),
          ),
        );
      },
      viewModelBuilder: () => EventDetailsViewModel(),
    );
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
