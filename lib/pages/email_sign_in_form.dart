import 'package:cyntralabs_challenge_app/models/email_sign_in_model.dart';
import 'package:cyntralabs_challenge_app/common_widgets/custom_raised_button.dart';
import 'package:cyntralabs_challenge_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:cyntralabs_challenge_app/pages/sign_up_page.dart';
import 'package:cyntralabs_challenge_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({
    Key key,
    @required this.model,
  }) : super(key: key);
  final EmailSignInModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => EmailSignInForm(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.signIn();
      // Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    _emailController.clear();
    _passwordController.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage.create(context),
        fullscreenDialog: true,
      ),
    );
  }

  List<Widget> _buildChildren() {
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
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 7,
            child: _buildEmailTextField(),
          ),
        ],
      ),
      SizedBox(height: 8.0),
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
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            flex: 7,
            child: _buildPasswordTextField(),
          ),
        ],
      ),
      SizedBox(height: 24.0),
      CustomRaisedButton(
        borderRadius: 30.0,
        child: Text(
          'Sign in',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        color: Colors.white,
        height: 50.0,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
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

  Widget _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
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
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.white),
      obscureText: true,
      onEditingComplete: _submit,
      onChanged: (password) => model.updatePassword(password),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: 'User',
        labelStyle: TextStyle(color: Colors.white),
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: (email) => model.updateEmail(email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 50.0,
        vertical: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
