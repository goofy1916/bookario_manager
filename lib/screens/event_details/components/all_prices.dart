import 'package:bookario_manager/models/event_model.dart';
import 'package:flutter/material.dart';

import '../event_details_screen_viewmodel.dart';
import 'display_prices.dart';

class AllPrices extends StatelessWidget {
  final EventModel event;
  final EventDetailsViewModel viewModel;

  const AllPrices({Key? key, required this.event, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (event.coupleEntry.isNotEmpty)
          ListofEntryPrices(
            passes: event.coupleEntry,
            passName: "Couple Entry",
            viewModel: viewModel,
          ),
        if (event.stagMaleEntry.isNotEmpty)
          ListofEntryPrices(
            passes: event.stagMaleEntry,
            passName: "Male Stag Entry",
            viewModel: viewModel,
          ),
        if (event.stagFemaleEntry.isNotEmpty)
          ListofEntryPrices(
            passes: event.stagFemaleEntry,
            passName: "Female Stag Entry",
            viewModel: viewModel,
          ),
        if (event.tableOption.isNotEmpty)
          ListofEntryPrices(
            passes: event.tableOption,
            passName: "Book Table",
            isTable: true,
            viewModel: viewModel,
          )
      ],
    );
  }
}
