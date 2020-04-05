import 'package:flutter/material.dart';
import '../config.dart';
import '../utils/Utils.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../views/truck_panel.dart';

class LoginView extends StatelessWidget {

	static String id = "login";

	void _onLogin(BuildContext context, UserType type) {
		User().updateUser(USERNAME, type);
		Navigator.pushNamed(context, TruckPanel.id);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: 
				Container(
    				margin: const EdgeInsets.only(top: 400, bottom: 400),
    				padding: const EdgeInsets.all(4.0),
    				alignment: Alignment.center,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						mainAxisSize: MainAxisSize.max,
						children: <Widget> [
							Text("Please select the user type",
								style: TextStyle(fontWeight: FontWeight.bold),
								 textAlign: TextAlign.center,),
							GestureDetector(
								onTap: () {
									_onLogin(context, UserType.Vendor);
								},
								child: Container(
						          color: UiColors.illinoisTransparentOrange05,
						          padding: const EdgeInsets.all(8),
						          child: const Text('Vendor'),
						          alignment: Alignment.center,
						        ),
							), // GestureDetector
							GestureDetector(
								onTap: () {
									_onLogin(context, UserType.User);
								},
								child: Container(
						          color: UiColors.illinoisTransparentOrange05,
						          padding: const EdgeInsets.all(8),
						          child: const Text('User'),
						          alignment: Alignment.center,
						        ),
							) // GestureDetector
						],
					) // Column
				)// Container	
			);
	}
}