import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../moduls/Archive Task/archived_task.dart';
import '../moduls/done Task/done_task.dart';
import '../moduls/new Tasks/new_task.dart';
import '../shared/component/component.dart';
import '../shared/component/constant.dart';


class HomeLayout extends StatelessWidget {




  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();
 // var statusController=TextEditingController();

  @override
  // void initState(){
  //   super.initState();
  //   createDataBase();
  // }
  Widget build(BuildContext context) {
    //AppCubit cubit1=AppCubit.get(context);
    return  BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: ( context, state){
          if (state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: ( context, state){
          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppCubit.get(context).title[AppCubit.get(context).currentindex],
              ),
            ),
            body:
                state is! AppGetDatabaseLoadingState?
              AppCubit.get(context).screens[AppCubit.get(context).currentindex]:
            // tasks.length==0?
             Center(child: CircularProgressIndicator()),

            floatingActionButton: FloatingActionButton(
              onPressed: (){

                if(AppCubit.get(context).isBottomSheetShown){
                  if((formKey.currentState!.validate())){
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text ,
                        date: dateController.text,
                        time: timeController.text);
                    // insertToDatabase(title:titleController.text ,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value) {
                    //   getDataFromDatabase(database).then((value){
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown=false;
                    //     //     fabIcon=Icons.edit;
                    //     //   tasks=value;
                    //     //   print(tasks);
                    //     // });
                    //
                    //   });
                    //
                    // });

                  }

                }
                else{
                  scaffoldKey.currentState?.showBottomSheet(
                          (context) => Container(
                        color: Colors.grey.shade100,
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                type:TextInputType.text,
                                validate: (String? value){
                                  if((value!.isEmpty)){
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                label:'Task Title',
                                prefix: Icon(Icons.title),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                controller: dateController,
                                type:TextInputType.datetime,
                                //isClickable: false,
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now() ,
                                      firstDate: DateTime.now() ,
                                      lastDate:DateTime.parse('2024-05-03'))
                                      .then(( value) {
                                    print(DateFormat.yMMMd().format(value!));
                                    dateController.text=DateFormat.yMMMd().format(value!);
                                    //print(value.format(context));
                                  });

                                },
                                validate: (String? value){
                                  if((value!.isEmpty)){
                                    return 'date must not be empty';
                                  }
                                  return null;
                                },
                                label:'task date',
                                prefix: Icon(Icons.calendar_today),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              defaultFormField(
                                // isClickable: false,
                                controller: timeController,
                                type:TextInputType.datetime,
                                onTap: (){
                                  showTimePicker(
                                    context: context,
                                    initialTime:TimeOfDay.now(), )
                                      .then((value) {
                                    timeController.text=value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                validate: (String? value){
                                  if((value!.isEmpty)){
                                    return 'time must not be empty';
                                  }
                                  return null;
                                },
                                label:'task time',
                                prefix: Icon(Icons.watch_later),
                              ),


                            ],
                          ),
                        ),
                      ),
                          elevation: 20.0,).closed.then((value){
                    //Navigator.pop(context);
                    AppCubit.get(context).ChangeBottomSheetState(
                        isShow:false,
                        icon: Icons.edit
                    );
                    // setState(() {
                    //   fabIcon=Icons.edit;
                    // });
                  });
                  AppCubit.get(context).ChangeBottomSheetState(
                      isShow: true,
                      icon: Icons.add
                  );
                  // setState(() {
                  //   fabIcon=Icons.add;
                  // });
                }
                // try{
                //   var name= await getName();
                //   print(name);
                //   throw('some error !!!!!!!!!');
                // }catch(error){
                //   print('error${error.toString()}');
                // }
                // getName().then((value) {
                //   print(value);
                //   print('shahd www');
                //   throw('انا عملت ايرور!!!!!!!!!');
                // }).catchError((error){
                //   print('error ${error.toString()}');
                // });
                //insertToDatabase();

              },
              child: Icon(
                AppCubit.get(context).fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 15.0,
              showSelectedLabels: false,
              currentIndex: AppCubit.get(context).currentindex,
              onTap: (index){
                // setState(() {
                AppCubit.get(context).changeIndex(index);
                // });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },

      ),
    );
  }
  // Future<String> getName()async
  // {
  //   return 'shahd';
  // }

}
