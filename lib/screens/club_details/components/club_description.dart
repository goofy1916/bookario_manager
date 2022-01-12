import 'package:bookario_manager/components/description_text.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/screens/club_details/club_details_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClubDescription extends StatelessWidget {
  final ClubDetailsViewModel viewModel;

  const ClubDescription({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: getProportionateScreenWidth(10),
            ),
            child: const Text(
              "About us",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          DescriptionTextWidget(text: viewModel.myClub.desc!),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Location point.svg",
                      height: getProportionateScreenWidth(15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: SelectableText(
                          viewModel.myClub.address!,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
