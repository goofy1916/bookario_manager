import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';

class EventDetailsTabBar extends StatelessWidget {
  const EventDetailsTabBar({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final EventDetailsViewModel viewModel;

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
                text: "Passes",
                function: () =>
                    viewModel.toggleDetailType(EventDetailsType.passes),
                isActive: viewModel.selectedEventDetailsType ==
                    EventDetailsType.passes,
              ),
              CustomTab(
                text: "Coupons",
                function: () =>
                    viewModel.toggleDetailType(EventDetailsType.coupons),
                isActive: viewModel.selectedEventDetailsType ==
                    EventDetailsType.coupons,
              ),
              CustomTab(
                text: "Promoter",
                function: () =>
                    viewModel.toggleDetailType(EventDetailsType.promoters),
                isActive: viewModel.selectedEventDetailsType ==
                    EventDetailsType.promoters,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key? key,
    required this.text,
    required this.function,
    required this.isActive,
  }) : super(key: key);

  final String text;
  final Function() function;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive ? kSecondaryColor : Colors.black,
          ),
          height: 40,
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
