import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/pass_type_model.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListofEntryPrices extends StatelessWidget {
  const ListofEntryPrices({
    Key? key,
    required this.passes,
    required this.passName,
    required this.viewModel,
    this.isTable = false,
  }) : super(key: key);

  final bool isTable;
  final List<PassType> passes;
  final String passName;
  final EventDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return !viewModel.isBusy
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(10),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Cash.svg",
                      height: getProportionateScreenWidth(10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      passName,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.white38),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: passes.map<Widget>(
                  (PassType pass) {
                    return Card(
                      color: kSecondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "${pass.type} : ₹ ${pass.entry} " +
                                          ((pass.cover > 0.0)
                                              ? "\n(Cover ₹${pass.cover})"
                                              : ""),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (isTable)
                                    Text(
                                      "Admits : ${pass.allowed}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () =>
                                    viewModel.removePass(getPassType(), pass),
                                child: const Icon(Icons.remove_circle,
                                    color: kPrimaryLightColor)),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  String getPassType() {
    if (passName.contains("Couple")) {
      return "coupleEntry";
    } else if (passName.contains("Male Stag")) {
      return "stagMaleEntry";
    } else if (passName.contains("Female")) {
      return "stagFemaleEntry";
    } else {
      return "tableOption";
    }
  }
}
