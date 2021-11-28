import 'package:bookario_manager/app.locator.dart';
import 'package:bookario_manager/components/constants.dart';
import 'package:bookario_manager/components/custom_suffix_icon.dart';
import 'package:bookario_manager/components/loading.dart';
import 'package:bookario_manager/components/size_config.dart';
import 'package:bookario_manager/screens/user_input_details/user_input_details_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UserInputDetailsView extends StatelessWidget {
  const UserInputDetailsView({Key? key, required this.user}) : super(key: key);

  final User user;

  Future _discardChanges(
    BuildContext context,
    UserInputDetailsViewModel viewModel,
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
          title: const Text(
            'Discard changes?',
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 0.7,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              splashColor: Theme.of(context).primaryColorLight,
              child: const Text(
                'No',
                style: TextStyle(
                    fontSize: 14, letterSpacing: .8, color: Colors.white70),
              ),
            ),
            MaterialButton(
              onPressed: () {
                viewModel.updateUserProfile();
              },
              splashColor: Theme.of(context).primaryColorLight,
              child: const Text(
                'Yes',
                style: TextStyle(
                    fontSize: 14, letterSpacing: .8, color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserInputDetailsViewModel>.reactive(
        builder: (context, viewModel, child) {
          viewModel.populateFields(user);
          return WillPopScope(
            onWillPop: () async =>
                locator<NavigationService>().back(result: false),
            child: Scaffold(
              key: viewModel.scaffoldKey,
              appBar: AppBar(
                title: const Text("Edit Profile"),
              ),
              body: SafeArea(
                child: viewModel.isBusy
                    ? const Loading()
                    : SingleChildScrollView(
                        child: Container(
                          height: SizeConfig.screenHeight * 0.8,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              nameFormField(context, viewModel),
                              const SizedBox(height: 20),
                              phoneNumberFormField(context, viewModel),
                              const SizedBox(height: 20),
                              ageFormField(viewModel),
                              const SizedBox(height: 20),
                              buildGenderFormField(viewModel, context),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  discardChanges(context, viewModel),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: kSecondaryColor,
                                    child: const Text(
                                      "Update",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await viewModel.updateUserProfile();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
        viewModelBuilder: () => UserInputDetailsViewModel());
  }

  TextFormField nameFormField(
      BuildContext context, UserInputDetailsViewModel viewModel) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.go,
      focusNode: viewModel.nameFocusNode,
      controller: viewModel.nameEditingController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          viewModel.removeError(error: "Name cannot be empty");
        }
        return;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          viewModel.addError(error: "Name cannot be empty");
          return "";
        }
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
      onFieldSubmitted: (value) {
        viewModel.nameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(viewModel.phoneNumberFocusNode);
      },
    );
  }

  TextFormField phoneNumberFormField(
      BuildContext context, UserInputDetailsViewModel viewModel) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.phone,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.go,
      focusNode: viewModel.phoneNumberFocusNode,
      controller: viewModel.phoneNumberEditingController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          viewModel.removeError(error: "Please Enter your Phone Number");
        } else if (value.length == 10) {
          viewModel.removeError(error: "Please Enter valid Phone Number");
        }
        return;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          viewModel.addError(error: "Please Enter your Phone Number");
          return "";
        } else if (value.length != 10) {
          viewModel.addError(error: "Please Enter valid Phone Number");
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Call-grey.svg"),
      ),
      onFieldSubmitted: (value) {
        viewModel.phoneNumberFocusNode.unfocus();
        FocusScope.of(context).requestFocus(viewModel.ageFocusNode);
      },
    );
  }

  TextFormField ageFormField(UserInputDetailsViewModel viewModel) {
    return TextFormField(
      style: const TextStyle(color: Colors.white70),
      keyboardType: TextInputType.number,
      cursorColor: Colors.white70,
      textInputAction: TextInputAction.done,
      focusNode: viewModel.ageFocusNode,
      controller: viewModel.ageEditingController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          viewModel.removeError(error: "Please Enter your age");
        }
        return;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          viewModel.addError(error: "Please Enter your age");
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Age",
        hintText: "Enter your age",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Age.svg"),
      ),
      onFieldSubmitted: (value) {
        viewModel.ageFocusNode.unfocus();
      },
    );
  }

  Expanded buildGenderFormField(
      UserInputDetailsViewModel viewModel, BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: viewModel.gender,
        dropdownColor: kSecondaryColor,
        style: const TextStyle(color: kPrimaryColor),
        onChanged: (String? value) {
          viewModel.gender = value;
        },
        items: ['Male', 'Female', 'Others']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
        validator: (value) => value == null ? 'Select Gender' : null,
        decoration: const InputDecoration(
          labelText: 'Gender',
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }

  MaterialButton discardChanges(
      BuildContext context, UserInputDetailsViewModel viewModel) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: const Text(
        "Discard",
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        _discardChanges(context, viewModel);
      },
    );
  }
}
