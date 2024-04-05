import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/component.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTask extends StatelessWidget {


@override
Widget build(BuildContext context) {
  return BlocConsumer<AppCubit,AppStates>(
      listener: ( context, state){

      },
      builder: ( context, state){
        return ListView.separated(
            itemBuilder: (context,index)=>buildTaskItem(AppCubit.get(context).arcivedTasks[index],context),
            separatorBuilder: (context,index)=>Padding(
              padding: const EdgeInsetsDirectional.only(
                  start:20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey.shade300 ,
              ),
            ),
            itemCount: AppCubit.get(context).arcivedTasks.length);}
  ) ;
}
}
