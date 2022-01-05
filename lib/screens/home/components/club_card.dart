import 'package:bookario_manager/app.router.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/club_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({
    Key? key,
    required this.club,
  }) : super(key: key);

  final ClubDetails club;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * .35,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.clubDetailsView,
            arguments: ClubDetailsViewArguments(club: club)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: SizedBox(
                    width: SizeConfig.screenWidth,
                    child: Hero(
                      tag: club.name!,
                      child: Image.network(
                        club.clubLogo!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 4, 12, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: club.name,
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                            children: [
                              TextSpan(
                                text: '  (${club.area})',
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(12),
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/Location point.svg",
                              height: getProportionateScreenWidth(13),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Flexible(
                              child: Text(
                                club.address.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
