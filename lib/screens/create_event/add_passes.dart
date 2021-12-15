import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'add_event.dart';
import 'add_event_viewmodel.dart';

Widget _passType(
  BuildContext context,
  String passType,
  AddEventViewModel viewModel,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 15),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/Cash.svg",
                        height: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        passType,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      IconButton(
          onPressed: () {
            viewModel.updateAddPassType(passType);
          },
          icon: const Icon(
            Icons.add_circle,
            color: Colors.white38,
          ))
    ],
  );
}

addPasses(AddEventViewModel viewModel, context) {
  return Column(
    children: [
      const Text(
        "Add Passes",
        style: TextStyle(color: kSecondaryColor, fontSize: 20),
      ),
      if (viewModel.selectedPassType == null) ...[
        _passType(context, "Couple Pass", viewModel),
        _passType(context, "Male Stag Pass", viewModel),
        _passType(context, "Female Stag Pass", viewModel),
        _passType(context, "Book Table", viewModel),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Back",
                press: () {
                  viewModel.setIndex(viewModel.currentIndex - 1);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultButton(
                text: "Next",
                press: () {
                  viewModel.setIndex(viewModel.currentIndex + 1);
                },
              ),
            )
          ],
        )
      ] else ...[
        Text(
          "${viewModel.selectedPassType}",
          style: const TextStyle(color: kSecondaryColor),
        ),
        if (viewModel.selectedPassType == couple) getCouplePassInput(viewModel),
        if (viewModel.selectedPassType == male) getMalePassInput(viewModel),
        if (viewModel.selectedPassType == female) getFemalePassInput(viewModel),
        if (viewModel.selectedPassType == table) getTablePassInput(viewModel),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                minWidth: 100,
                color: kSecondaryColor,
                onPressed: () {
                  viewModel.clearSelectedPassType();
                },
                child: const Text("Cancel"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                minWidth: 100,
                color: kSecondaryColor,
                onPressed: () {
                  viewModel.addPass();
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ],
      const Text(
        "Added",
        style: TextStyle(color: kSecondaryColor, fontSize: 20),
      ),
      const SizedBox(height: 20),
      SingleChildScrollView(
        child: Column(
          children: [
            ...viewModel.couplePasses.map((e) {
              return e['passTitle'] != null
                  ? customListTile(e, viewModel, couple)
                  : const SizedBox.shrink();
            }),
            ...viewModel.malePasses.map((e) => e['passTitle'] != null
                ? customListTile(e, viewModel, male)
                : const SizedBox.shrink()),
            ...viewModel.femalePasses.map((e) => e['passTitle'] != null
                ? customListTile(e, viewModel, female)
                : const SizedBox.shrink()),
            ...viewModel.tablePasses.map((e) => e['passTitle'] != null
                ? customListTile(e, viewModel, table)
                : const SizedBox.shrink())
          ],
        ),
      )
    ],
  );
}

customListTile(
    Map<String, dynamic> e, AddEventViewModel viewModel, String type) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          e['passTitle'].toString(),
          style: const TextStyle(color: kSecondaryColor),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.remove_circle,
            color: kSecondaryColor,
          ),
          onPressed: () => viewModel.removePass(type, e['passTitle']),
        ),
      ),
    ),
  );
}

getCouplePassInput(AddEventViewModel viewModel) {
  return Column(
    children: [
      customTextFormField("Pass title",
          viewModel.couplePasses.last[passNameController], "Enter pass name"),
      customNumberFormField("Total Cost",
          viewModel.couplePasses.last[totalCostController], "Enter pass cost"),
      customNumberFormField(
          "Total Cover",
          viewModel.couplePasses.last[totalCoverController],
          "Enter cover cost"),
    ],
  );
}

getMalePassInput(AddEventViewModel viewModel) {
  return Column(
    children: [
      customTextFormField("Pass title",
          viewModel.malePasses.last[passNameController], "Enter pass name"),
      customNumberFormField("Total Cost",
          viewModel.malePasses.last[totalCostController], "Enter pass cost"),
      customNumberFormField("Total Cover",
          viewModel.malePasses.last[totalCoverController], "Enter cover cost"),
    ],
  );
}

getFemalePassInput(AddEventViewModel viewModel) {
  return Column(
    children: [
      customTextFormField("Pass title",
          viewModel.femalePasses.last[passNameController], "Enter pass name"),
      customNumberFormField("Total Cost",
          viewModel.femalePasses.last[totalCostController], "Enter pass cost"),
      customNumberFormField(
          "Total Cover",
          viewModel.femalePasses.last[totalCoverController],
          "Enter cover cost"),
    ],
  );
}

getTablePassInput(AddEventViewModel viewModel) {
  return Column(
    children: [
      customTextFormField("Pass title",
          viewModel.tablePasses.last[passNameController], "Enter pass name"),
      customNumberFormField("Total Cost",
          viewModel.tablePasses.last[totalCostController], "Enter pass cost"),
      customNumberFormField("Total Cover",
          viewModel.tablePasses.last[totalCoverController], "Enter cover cost"),
      customNumberFormField(
          "Total Allowed",
          viewModel.tablePasses.last[totalAllowedController],
          "Enter total allowed at the table"),
    ],
  );
}
