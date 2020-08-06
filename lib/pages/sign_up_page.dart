import 'package:cyntralabs_challenge_app/common_widgets/custom_raised_button.dart';
import 'package:cyntralabs_challenge_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:cyntralabs_challenge_app/models/email_sign_in_model.dart';
import 'package:cyntralabs_challenge_app/pages/sign_in_page.dart';
import 'package:cyntralabs_challenge_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({@required this.model});
  final EmailSignInModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => SignUpPage(
          model: model,
        ),
      ),
    );
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  EmailSignInModel get model => widget.model;

  Future<void> _submit() async {
    //final database = Provider.of<FirestoreService>(context, listen: false);
    try {
      await model.signUp();
      //Get Current user and set details to firestore
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _toggleFormType() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 15.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'New Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => print('Upload image'),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    maxRadius: 50.0,
                    backgroundImage: null,
                    child: Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                      size: 35.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: _buildFormChildren(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          Expanded(
            flex: 6,
            child: _buildUserNameTextField(),
          ),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.email,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          Expanded(flex: 6, child: _buildEmailTextField()),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.lock_outline,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          Expanded(
            flex: 6,
            child: _buildPasswordField(),
          ),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.cake,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          Expanded(
            flex: 5,
            child: _buildDobTextField(),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      SizedBox(
        height: 15.0,
      ),
      Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.location_city,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 6,
            child: Text(
              'Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 20.0,
      ),
      SizedBox(
        width: 250.0,
        child: CustomRaisedButton(
          borderRadius: 30.0,
          onPressed: model.canSubmit ? _submit : null,
          child: Text(
            'Create',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          color: Colors.white,
          height: 50.0,
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            Text(
              // model.signUpSignInText,
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildUserNameTextField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'User Name',
        labelStyle: TextStyle(color: Colors.white),
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white),
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      textInputAction: TextInputAction.next,
      onChanged: (email) => widget.model.updateEmail(email),
    );
  }

  TextField _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white),
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.white),
      obscureText: true,
      onChanged: (password) => widget.model.updatePassword(password),
    );
  }

  TextField _buildDobTextField() {
    return TextField(
      controller: _dobController,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'Birthday',
        labelStyle: TextStyle(color: Colors.white),
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.white),
      obscureText: true,
    );
  }
}
