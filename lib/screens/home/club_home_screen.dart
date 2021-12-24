import 'dart:io';
import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/screens/home/components/my_clubs.dart';
import 'package:bookario_manager/screens/home/home_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ClubHomeScreen extends StatelessWidget {
  const ClubHomeScreen({Key? key}) : super(key: key);

  Future _exitApp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            "Want to exit?",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => false,
              splashColor: Colors.red[50],
              child: Text(
                "No",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
            MaterialButton(
              onPressed: () => true,
              splashColor: Colors.red[50],
              child: Text(
                "Yes",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ViewModelBuilder<HomeScreenViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getMyClubs(),
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              leading: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/images/onlylogo.png",
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text("Home"),
              actions: [
                IconButton(
                    onPressed: () => _logout(context, viewModel),
                    icon: const Icon(Icons.exit_to_app))
              ],
            ),
            body: viewModel.isBusy
                ? const Loading()
                : viewModel.hasClubs
                    ? showClubs(context, viewModel)
                    : Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Register your club by\nclicking on \'+\' button below.',
                          textAlign: TextAlign.center,
                        ),
                      ),
          );
        },
        viewModelBuilder: () => HomeScreenViewModel());
  }

  Widget showClubs(BuildContext context, HomeScreenViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(5)),
          MyClubs(clubData: viewModel.myClubs!),
          SizedBox(height: getProportionateScreenWidth(10)),
          viewModel.loadMore
              ? viewModel.loadingMore
                  ? const Loading()
                  : MaterialButton(
                      onPressed: () {
                        // loadingMore = true;
                        // offset += limit;

                        // getMyClubs();
                      },
                      splashColor: Theme.of(context).primaryColorLight,
                      child: const Text(
                        'load more',
                        style: TextStyle(color: kTextColor),
                      ),
                    )
              : Container(),
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }

  Future _logout(BuildContext context, HomeScreenViewModel viewModel) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            "Want to logout?",
            style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              splashColor: Colors.red[50],
              child: Text(
                "No",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                viewModel.logout();
                // _localStorageService.deleteStore('userType');
                // await _auth.signOut();
              },
              splashColor: kPrimaryColor,
              child: Text(
                "Yes",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future clubAddedAlert(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: Text(
            "Club Added Successully",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontSize: 17, color: Colors.white),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              splashColor: Colors.red[50],
              child: Text(
                "Ok",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
