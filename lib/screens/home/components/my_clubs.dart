import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:bookario_manager/screens/home/components/club_card.dart';
import 'package:flutter/material.dart';

class MyClubs extends StatelessWidget {
  final List<ClubDetails> clubData;
  const MyClubs({Key? key, required this.clubData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              clubData.length,
              (index) {
                return ClubCard(club: clubData[index]);
              },
            ),
            SizedBox(width: getProportionateScreenWidth(10)),
          ],
        ),
      ),
    );
  }
}
