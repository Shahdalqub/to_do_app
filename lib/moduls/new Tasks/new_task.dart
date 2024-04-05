import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/component.dart';
import '../../shared/component/constant.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';



class NewTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
        listener: ( context, state){

    },
    builder: ( context, state){
      return (AppCubit.get(context).tasks.length>0)?
        ListView.separated(
          itemBuilder: (context,index)=>buildTaskItem(AppCubit.get(context).tasks[index],context),
          separatorBuilder: (context,index)=>Padding(
            padding: const EdgeInsetsDirectional.only(
                start:20.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
               color: Colors.grey.shade300 ,
            ),
          ),
          itemCount: AppCubit.get(context).tasks.length):
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
            size: 100.0,
            color: Colors.grey,),
            Text(
                'No tasks yet,please add some tasks',
            style: TextStyle(
              fontSize:16.0 ,
              fontWeight: FontWeight.bold,
            ),
            )
          ],
        ),
      );
        }
    ) ;
  }
}
