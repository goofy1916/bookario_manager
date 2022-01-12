import 'package:bookario_manager/components/custom_tab.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/screens/club_details/club_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EventTypeSwitcher extends StatelessWidget {
  const EventTypeSwitcher({Key? key, required this.viewModel})
      : super(key: key);

  final ClubDetailsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomTab(
                text: "Upcoming",
                function: () => viewModel.toggleEventType(EventType.upcoming),
                isActive: viewModel.selectedEventType == EventType.upcoming,
              ),
              CustomTab(
                text: "Past",
                function: () => viewModel.toggleEventType(EventType.past),
                isActive: viewModel.selectedEventType == EventType.past,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
