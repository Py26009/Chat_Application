import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:chat_application/OnBoarding/LoginCubit/login%20cubit.dart';
import 'package:chat_application/OnBoarding/SignUpCubit/SignUpCubit.dart';
import 'package:chat_application/Screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(RepositoryProvider(
      create: (context) => FireBaseRepository(),
 child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>LoginCubit(fireBaseRepository: RepositoryProvider.of<FireBaseRepository>(context))),
        BlocProvider(create: (context)=>SignUpCubit(firebaseRepository: RepositoryProvider.of<FireBaseRepository>(context))),
      ],
      child:MyApp(),
  )
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
    );
  }
}


