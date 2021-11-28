import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/details/details_screen.dart';
import 'package:bookario_manager/screens/eventDetails/event_details.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * .96,
      height: getProportionateScreenWidth(80),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(event: event)),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.96,
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          event.eventThumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      flex: 8,
                      child: Text(
                        event.name + '\n' + getDateOfEvent(event.dateTime),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
