import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/screens/add_promoter/add_promoter_viewmodel.dart';
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            "Promoters",
                            style:
                                TextStyle(color: kSecondaryColor, fontSize: 18),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                ...viewModel.selectedPromoters.map(
                                    (e) => customListTile(e.name, viewModel))
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextFormField(
                              fieldTitle: "Search Promoter",
                              fieldController:
                                  viewModel.searchPromoterController,
                              fieldHint: "Enter promoter id",
                              onChanged: viewModel.updatePromoterSearchList,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                children: [
                                  ...viewModel.promoterSearchList.map(
                                    (promoter) => Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade800),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(promoter.promoterId),
                                              Checkbox(
                                                activeColor: Colors.green,
                                                value: viewModel
                                                    .selectedPromoters
                                                    .contains(promoter),
                                                onChanged: (value) => viewModel
                                                    .updateSelectedPromoters(
                                                        promoter: promoter,
                                                        add: value ?? false),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: kPrimaryColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          DefaultButton(
                              press: () => viewModel.addPromoters(),
                              text: "Add"),
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}

customListTile(String title, AddPromoterViewModel viewModel) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Chip(
      label: Text(
        title,
        style: const TextStyle(color: kSecondaryColor),
      ),
    ),
  );
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.fieldController,
      required this.fieldTitle,
      required this.fieldHint,
      required this.onChanged})
      : super(key: key);

  final TextEditingController fieldController;
  final String fieldTitle;
  final String fieldHint;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: const TextStyle(color: Colors.white70),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        cursorColor: Colors.white70,
        // focusNode: viewModel.nameFocusNode,
        onChanged: onChanged,
        controller: fieldController,
        validator: (String? val) {
          if (val == null) {
            return "Enter valid value!";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: fieldTitle,
          hintText: fieldHint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
