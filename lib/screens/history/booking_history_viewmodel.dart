import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/models/event_pass_model.dart';
import 'package:bookario_manager/services/firebase_service.dart';
import 'package:stacked/stacked.dart';

enum PassType { checkedIn, remaining }

class BookingHistoryViewModel extends BaseViewModel {
  List<bool> isExpanded = [];
  List<EventPass> eventPasses = [];
  List<EventPass> checkedInPasses = [];
  List<EventPass> remainingPasses = [];

  PassType passType = PassType.checkedIn;

  final FirebaseService _firebaseService = locator<FirebaseService>();

  void updateIsExpanded(int index) {
    isExpanded[index] = !isExpanded[index];
    notifyListeners();
  }

  Future getBookingData(String eventId) async {
    setBusy(true);
    eventPasses = await _firebaseService.getPasses(eventId);
    for (final i in eventPasses) {
      if (i.checked) {
        checkedInPasses.add(i);
      } else {
        remainingPasses.add(i);
      }
      isExpanded.add(false);
    }
    eventPasses
        .sort((EventPass a, EventPass b) => b.timeStamp.compareTo(a.timeStamp));
    setBusy(false);
  }

  toggleToRemaining() {
    passType = PassType.remaining;
    notifyListeners();
  }

  toggleToCheckedIn() {
    passType = PassType.checkedIn;
    notifyListeners();
  }
}
