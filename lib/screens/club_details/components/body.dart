import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/screens/club_details/club_details_screen_viewmodel.dart';
import 'package:bookario_manager/screens/club_details/club_event/club_events.dart';
import 'package:bookario_manager/screens/create_event/add_event.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'club_description.dart';
import 'custom_app_bar.dart';

class Body extends StatelessWidget {
  final ClubDetails club;
  const Body({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClubDetailsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getMyEvents(club),
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppBar(
                      clubId: club.name!,
                      title: club.name!,
                      location: club.area!,
                    ),
                    ClubDescription(club: club),
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
                          Container(
                            alignment: Alignment.center,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                top: 6,
                                bottom: 18,
                              ),
                              child: Text(
                                "Your upcoming events",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
                    ),
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
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
