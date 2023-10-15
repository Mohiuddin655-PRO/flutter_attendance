import 'package:flutter/material.dart';
import 'package:flutter_attendence/dashboard/dashboard.dart';
import 'package:flutter_attendence/sign_in/auth_sign_in.dart';
import 'package:flutter_attendence/user.dart';
import 'package:flutter_attendence/utils/api_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(builder: (context) {
        final user = User.fromPreferences(preferences);
        if (user.accessToken != null) {
          return FutureBuilder(
            future: AuthHelpers.check(token: user.accessToken ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.isRight()) {
                  return const Dashboard();
                } else {
                  return const AuthSignIn();
                }
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        } else {
          return const AuthSignIn();
        }
      }),
    );
  }
}
