import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/signup');
          },
          child: const Text('Sign Up'),
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'signup/personal_info',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'signup/personal_info':
            builder = (BuildContext context) => const CollectPersonalInfoPage();
          case 'signup/credentials':
            builder = (BuildContext context) => ChooseCredentialsPage(
                  onSignUpComplete: () {
                    // rootNavigator: true 속성을 사용하여 루트 네비게이터를 사용하여 팝업
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                );
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class ChooseCredentialsPage extends StatelessWidget {
  const ChooseCredentialsPage({super.key, required this.onSignUpComplete});

  final VoidCallback onSignUpComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credentials'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: onSignUpComplete,
          child: const Text('Sign Up Complete'),
        ),
      ),
    );
  }
}

class CollectPersonalInfoPage extends StatelessWidget {
  const CollectPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Info'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('signup/credentials');
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}
