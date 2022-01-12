import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/screens/club_details/club_details_screen_viewmodel.dart';
import 'package:bookario_manager/screens/club_details/club_event/club_events.dart';
import 'package:bookario_manager/screens/club_details/components/club_description.dart';
import 'package:bookario_manager/screens/club_details/components/custom_app_bar.dart';
import 'package:bookario_manager/screens/club_details/components/event_types.dart';
import 'package:bookario_manager/screens/create_event/add_event.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ClubDetailsView extends StatelessWidget {
  final ClubDetails club;

  const ClubDetailsView({
    Key? key,
    required this.club,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClubDetailsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getMyEvents(club),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomAppBar(
                        clubId: club.name!,
                        title: club.name!,
                        location: club.area!,
                      ),
                      ClubDescription(
                        viewModel: viewModel,
                      ),
                      if (viewModel.isBusy)
                        const Loading()
                      else
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          color: Colors.black,
                          child: Column(
                            children: [
                              divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              EventTypeSwitcher(
                                viewModel: viewModel,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (viewModel.hasEvents)
                                showEvents(context, viewModel)
                              else
                                Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'No Events.',
                                    style: TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black12,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 0.15,
                        right: SizeConfig.screenWidth * 0.15,
                        bottom: getProportionateScreenWidth(10),
                        top: getProportionateScreenWidth(2),
                      ),
                      child: DefaultButton(
                        text: "Add Event",
                        press: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEvent(club: club),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => ClubDetailsViewModel(),
    );
  }

  SingleChildScrollView showEvents(
      BuildContext context, ClubDetailsViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ClubEvents(
            viewModel: viewModel,
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
