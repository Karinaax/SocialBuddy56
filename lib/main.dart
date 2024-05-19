import 'package:buddy_animation/animated_eyes_view.dart';
import 'package:flutter/material.dart';

import 'flic_button_connection_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         useMaterial3: true,
//       ),
//       home: const AnimatedEyesView(),
//     );
//   }
// }

void main() {
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: FlicButtonPage(onButtonPressed: () {  },),
    );
  }
}
//
// // void main() {
// //   runApp(MyApp());
// //
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       // Your MaterialApp widget here
// //     );
// //   }
// // }


