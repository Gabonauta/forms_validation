import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:forms_validation/Providers/login_form_provider.dart';
import 'package:forms_validation/services/services.dart';
import 'package:forms_validation/ui/input_decorations.dart';
import 'package:forms_validation/widgets/auth_background.dart';
import 'package:forms_validation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180,
            ),
            CardContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Registro',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: _LoginForm(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  Colors.indigo.withOpacity(0.1),
                ),
                shape: MaterialStateProperty.all(
                  StadiumBorder(),
                ),
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              child: Text(
                'Ya tengo una cuenta',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
        key: loginForm.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'example@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Ingrese correo válido';
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'pass',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                if (value != null && value.length >= 6) return null;
                return 'Mínimo requerido de 6 caracteres';
              },
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: loginForm.isloading
                  ? null
                  : () async {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      if (!loginForm.isValidForm()) return;

                      FocusScope.of(context).unfocus();
                      await Future.delayed(Duration(seconds: 2));
                      loginForm.isLoading = true;
                      final String? token = await authService.createUser(
                          loginForm.email, loginForm.password);
                      if (token == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        print(token);
                        loginForm.isLoading = false;
                      }
                    },
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                child: Text(
                  loginForm.isloading ? 'Espere...' : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
