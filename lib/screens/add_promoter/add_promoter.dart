import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/models/promoter_model.dart';
import 'package:bookario_manager/screens/add_promoter/add_promoter_viewmodel.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddPromoters extends StatelessWidget {
  const AddPromoters({
    Key? key,
    required this.eventId,
    required this.promoters,
  }) : super(key: key);

  final String eventId;
  final List<String> promoters;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddPromoterViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getPromoters(eventId, promoters),
        viewModelBuilder: () => AddPromoterViewModel(),
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Add promoters"),
              ),
              body: viewModel.isBusy
                  ? const Loading()
                  : Column(
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
                                dropdownSearchDecoration: const InputDecoration(
                                    labelText: "Pomoters"),
                                onChanged: viewModel.updateSelectedPromoters,
                                // popupItemDisabled: (PromoterModel s) => s.startsWith('I'),
                                selectedItems: viewModel.selectedPromoters,
                                showSelectedItems: false),
                          ),
                          const Text(
                            "Promoters",
                            style:
                                TextStyle(color: kSecondaryColor, fontSize: 18),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView(
                              children: [
                                ...viewModel.selectedPromoters.map(
                                    (e) => customListTile(e.name, viewModel))
                              ],
                            ),
                          ),
                        ],
                        DefaultButton(
                            press: () => viewModel.addPromoters(), text: "Add"),
                      ],
                    ),
            ),
          );
        });
  }
}

customListTile(String title, AddPromoterViewModel viewModel) {
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
