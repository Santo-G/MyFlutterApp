import 'package:flutter/material.dart';
import '../generated/l10n.dart';


class LoginPage extends StatefulWidget {
  const LoginPage ({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  String? _email;
  String? _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Email richiesta';
          }
          return null;
        },
        onSaved: (String? value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Password richiesta';
          }
          return null;
        },
        onSaved: (String? value) {
          _password = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 200,
                  height: 100,
                  child: FlutterLogo(),
                ),
                const SizedBox(height: 8),
                _buildEmail(),
                _buildPassword(),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _formKey.currentState!.save();

                    print(_email);
                    print(_password);
                  },
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: Center(
                      child: Text(
                          S.current.loginButton,
                          textScaleFactor: 1.5,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}