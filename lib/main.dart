import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/layout/home_lalyout.dart';
import 'package:to_do_app/shared/bloc_observing.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget{
@override
Widget build(BuildContext context){
  return  MaterialApp(
    debugShowCheckedModeBanner:false ,
    home:HomeLayout(),
  );
}
}