// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'view_models/home_view_model.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
//       child: MaterialApp(
//         title: 'Vector',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: const Scaffold(body: Center(child: Text('Vector'))),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'views/welcome_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const VectorApp());
}

class VectorApp extends StatelessWidget {
  const VectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeView(),
    );
  }
}
