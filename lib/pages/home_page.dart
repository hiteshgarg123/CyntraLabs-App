import 'package:cyntralabs_challenge_app/common_widgets/custom_raised_button.dart';
import 'package:cyntralabs_challenge_app/common_widgets/platform_alert_dialog.dart';
import 'package:cyntralabs_challenge_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:cyntralabs_challenge_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignout = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout ?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignout == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Signout Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is Homepage',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            CustomRaisedButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
              color: Colors.indigo,
              borderRadius: 20.0,
              height: 40.0,
              onPressed: () => _confirmSignOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
