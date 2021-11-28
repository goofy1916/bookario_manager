import 'package:bookario_manager/models/club_details.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class ClubDetailsView extends StatelessWidget {
  final ClubDetails club;

  const ClubDetailsView({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(club: club),
    );
  }
}
