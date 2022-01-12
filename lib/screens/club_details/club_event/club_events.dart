import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/screens/club_details/club_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'event_card.dart';

class ClubEvents extends StatelessWidget {
  const ClubEvents({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final ClubDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              viewModel.getEvents.length,
              (index) {
                return EventCard(
                  event: viewModel.getEvents[index],
                  onEdit: () => viewModel.editEvent(viewModel.getEvents[index]),
                );
              },
            ),
            SizedBox(width: getProportionateScreenWidth(10)),
          ],
        ),
      ),
    );
  }
}
