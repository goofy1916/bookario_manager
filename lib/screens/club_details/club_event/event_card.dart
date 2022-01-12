import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/enum.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/models/event_model.dart';
import 'package:bookario_manager/screens/event_details/event_details_screen.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.event,
    required this.onEdit,
  }) : super(key: key);

  final EventModel event;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * .96,
      height: getProportionateScreenWidth(80),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventDetailsView(
                    event: event,
                    eventDisplayType: EventDisplayType.edit,
                  )),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: SizeConfig.screenWidth * 0.96,
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
              const SizedBox(width: 10),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (event.premium)
                      const Text(
                        "Premium Event",
                        style: TextStyle(color: kSecondaryColor),
                      ),
                    Text(
                      event.name + '\n' + getDateOfEvent(event.dateTime),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
              Flexible(
                  child: InkWell(
                onTap: onEdit,
                child: const SizedBox(
                  width: 50,
                  child: Icon(
                    Icons.edit,
                    color: kSecondaryColor,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
