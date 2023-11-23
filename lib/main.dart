import 'package:byminuser/repositories/auth_repository.dart';
import 'package:byminuser/screens/login.dart';
import 'package:byminuser/screens/orders.dart';
import 'package:byminuser/screens/profile.dart';
import 'package:byminuser/screens/splash.dart';
import 'package:byminuser/screens/wishpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_value/shared_value.dart';
import 'dart:async';
import 'app_config.dart';
import 'helpers/shared_value_helper.dart';
import 'my_theme.dart';


 main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /*fetch_user() async{
    var userByTokenResponse =
    await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$  = true;
      user_id.$ = userByTokenResponse.id!;
      user_name.$ = userByTokenResponse.name!;
      user_email.$ = userByTokenResponse.email!;
      user_phone.$ = userByTokenResponse.phone!;
      avatar_original.$ = userByTokenResponse.avatar_original!;
    }
  }*/
  access_token.load().whenComplete(() {
    /*fetch_user();*/
  });










  /*is_logged_in.load();
  user_id.load();
  avatar_original.load();
  user_name.load();
  user_email.load();
  user_phone.load();*/

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));


  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: AppConfig.app_name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        hintColor: MyTheme.accent_color,
        /*textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(fontSize: 12.0),
          )*/
        //
        // the below code is getting fonts from http
        // textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
        //   bodyText1: GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
        //   bodyText2: GoogleFonts.sourceSansPro(
        //       textStyle: textTheme.bodyText2, fontSize: 12),
        // ),
      ),
      home: Splash(),
      // home: Profile(),
      // home: OrdersPages(),
       // home: WishListPage(),
      // home: Main(),
    );
  }
}
