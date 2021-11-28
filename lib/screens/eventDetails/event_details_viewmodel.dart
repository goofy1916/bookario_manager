import 'package:bookario_manager/models/event_model.dart';
import 'package:stacked/stacked.dart';

class EventDetailsViewModel extends BaseViewModel {
  // final _formKey = GlobalKey<FormState>();
  // bool addingCouopn = false,
  //     loading = false,
  //     couponsLoading = true,
  //     couponsNotLoaded = false;
  // String discountName, discountPercent, couponQuantity;
  // List myCoupons = [];

  // FocusNode couponNameFocusNode = FocusNode();
  // FocusNode couponPercentFocusNode = FocusNode();
  // FocusNode couponQuantityFocusNode = FocusNode();

  late EventModel currentEvent;

  updateEvent({required EventModel event}) {
    currentEvent = event;
  }
}
