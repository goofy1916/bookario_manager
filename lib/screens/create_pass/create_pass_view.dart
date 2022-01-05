import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/custom_number_field.dart';
import 'package:bookario_manager/components/custom_text_form_field.dart';
import 'package:bookario_manager/components/default_button.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/create_event/add_event.dart';
import 'package:bookario_manager/screens/create_pass/create_pass_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class CreatePassView extends StatelessWidget {
  const CreatePassView({Key? key, required this.event}) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreatePassViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.updateEventId(event),
      builder:
          (BuildContext context, CreatePassViewModel viewModel, Widget? child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text("Add passes")),
            body: addPasses(viewModel, context),
          ),
        );
      },
      viewModelBuilder: () => CreatePassViewModel(),
    );
  }
}

Widget _passType(
  BuildContext context,
  String passType,
  CreatePassViewModel viewModel,
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

addPasses(CreatePassViewModel viewModel, context) {
  return SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(
          height: 20,
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
                  text: "Add passes",
                  press: () {
                    viewModel.addPassesToEvent();
                  },
                ),
              ),
            ],
          )
        ] else ...[
          Text(
            "${viewModel.selectedPassType}",
            style: const TextStyle(color: kSecondaryColor),
          ),
          if (viewModel.selectedPassType == couple)
            getCouplePassInput(viewModel),
          if (viewModel.selectedPassType == male) getMalePassInput(viewModel),
          if (viewModel.selectedPassType == female)
            getFemalePassInput(viewModel),
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
          "Added passes",
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
    ),
  );
}

customListTile(
    Map<String, dynamic> e, CreatePassViewModel viewModel, String type) {
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

getCouplePassInput(CreatePassViewModel viewModel) {
  return Column(
    children: [
      CustomTextFormField(
          fieldTitle: "Pass title",
          fieldController: viewModel.couplePasses.last[passNameController],
          fieldHint: "Enter pass name"),
      CustomNumberFormField(
          fieldTitle: "Total Cost",
          fieldController: viewModel.couplePasses.last[totalCostController],
          fieldHint: "Enter pass cost"),
      CustomNumberFormField(
          fieldTitle: "Total Cover",
          fieldController: viewModel.couplePasses.last[totalCoverController],
          fieldHint: "Enter cover cost"),
    ],
  );
}

getMalePassInput(CreatePassViewModel viewModel) {
  return Column(
    children: [
      CustomTextFormField(
          fieldTitle: "Pass title",
          fieldController: viewModel.malePasses.last[passNameController],
          fieldHint: "Enter pass name"),
      CustomNumberFormField(
          fieldTitle: "Total Cost",
          fieldController: viewModel.malePasses.last[totalCostController],
          fieldHint: "Enter pass cost"),
      CustomNumberFormField(
          fieldTitle: "Total Cover",
          fieldController: viewModel.malePasses.last[totalCoverController],
          fieldHint: "Enter cover cost"),
    ],
  );
}

getFemalePassInput(CreatePassViewModel viewModel) {
  return Column(
    children: [
      CustomTextFormField(
          fieldTitle: "Pass title",
          fieldController: viewModel.femalePasses.last[passNameController],
          fieldHint: "Enter pass name"),
      CustomNumberFormField(
          fieldTitle: "Total Cost",
          fieldController: viewModel.femalePasses.last[totalCostController],
          fieldHint: "Enter pass cost"),
      CustomNumberFormField(
          fieldTitle: "Total Cover",
          fieldController: viewModel.femalePasses.last[totalCoverController],
          fieldHint: "Enter cover cost"),
    ],
  );
}

getTablePassInput(CreatePassViewModel viewModel) {
  return Column(
    children: [
      CustomTextFormField(
          fieldTitle: "Pass title",
          fieldController: viewModel.tablePasses.last[passNameController],
          fieldHint: "Enter pass name"),
      CustomNumberFormField(
          fieldTitle: "Total Cost",
          fieldController: viewModel.tablePasses.last[totalCostController],
          fieldHint: "Enter pass cost"),
      CustomNumberFormField(
          fieldTitle: "Total Cover",
          fieldController: viewModel.tablePasses.last[totalCoverController],
          fieldHint: "Enter cover cost"),
      CustomNumberFormField(
          fieldTitle: "Total Allowed",
          fieldController: viewModel.tablePasses.last[totalAllowedController],
          fieldHint: "Enter total allowed at the table"),
    ],
  );
}
