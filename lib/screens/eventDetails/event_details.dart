import 'package:bookario_manager/models/event_model.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(event: event),
    );
  }
}
