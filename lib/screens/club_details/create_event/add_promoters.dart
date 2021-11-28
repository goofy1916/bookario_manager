import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/models/promoter_model.dart';
import 'package:bookario_manager/screens/club_details/create_event/add_event_viewmodel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

addPromoters(AddEventViewModel viewModel, BuildContext context) {
  return Column(
    children: [
      ...[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownSearch<PromoterModel>.multiSelection(
              mode: Mode.MENU,
              // showSelectedItem: true,
              items: viewModel.promoters,
              itemAsString: (PromoterModel? promoter) =>
                  promoter!.promoterId.toString(),
              dropdownSearchDecoration:
                  const InputDecoration(labelText: "Pomoters"),
              onChanged: viewModel.updateSelectedPromoters,
              // popupItemDisabled: (PromoterModel s) => s.startsWith('I'),
              selectedItems: viewModel.selectedPromoters,
              showSelectedItems: false),
        ),
        const Text(
          "Promoters",
          style: TextStyle(color: kSecondaryColor, fontSize: 18),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: ListView(
            children: [
              ...viewModel.selectedPromoters
                  .map((e) => customListTile(e.name, viewModel))
            ],
          ),
        ),
      ],
      DefaultButton(press: () => viewModel.createEvent(), text: "Create"),
    ],
  );
}

customListTile(String title, AddEventViewModel viewModel) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: kSecondaryColor),
        ),
      ),
    ),
  );
}
