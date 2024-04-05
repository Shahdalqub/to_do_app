import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/cubit/states.dart';

import '../../moduls/Archive Task/archived_task.dart';
import '../../moduls/done Task/done_task.dart';
import '../../moduls/new Tasks/new_task.dart';
import '../component/constant.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  late Database database;
  List<Map> tasks=[];
  //List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> arcivedTasks=[];
  int currentindex=0;
  List<Widget> screens=[
    NewTaskScreen(),
    DoneTask(),
    ArchivedTask(),
  ];
  List<String> title=[
    'New Task',
    'Done Task',
    'Archive Task',
  ];
  void changeIndex(int index){
    currentindex=index;
    emit(AppChangeBottomNavBarState());
  }
  void createDataBase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version){
        print('database created');
        database.execute('Create Table tasks'
            '(id INTEGER PRIMARY KEY,'
            'title TEXT,'
            'date TEXT,'
            'time TEXT,'
            'status TEXT)'
        ).then((value) {
          print('table created');
        }).catchError((error){
          print('error when created table ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
     });

  }
   insertToDatabase(
      {required String title,
        required String date,
        required String time,
      }) async {
    await database.transaction((txn) async {
      try {
        final value = await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) '
              'VALUES("$title","$date","$time","new")',
        );
        print("$value insert successful");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      } catch (error) {
        print('Error when inserting new row: ${error.toString()}');
      }
    });
   // emit(AppInsertDatabaseState());
  }
  void getDataFromDatabase(database){
    tasks=[];
     doneTasks=[];
     arcivedTasks=[];
emit(AppGetDatabaseLoadingState());
      database.rawQuery('SELECT * FROM tasks').then((value) {

        value.forEach((element) {
          if(element['status']=='new'){
            tasks.add(element);
          }
          else if(element['status']=='done'){
            doneTasks.add(element);
          }
          else{
            arcivedTasks.add(element);
          }
          print(element['status']);
        });
        emit(AppGetDatabaseState());
      });
  }
  void updateData({
    required String status,
    required int id,
})async{
    try{
      int count = await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
      );
      print('updated: $count');
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());

    }catch (error) {
      print('Error when update new row: ${error.toString()}');
    }
  }
  void deleteData({
    required int id,
  })async{
    try{
      int count = await database.rawDelete(
          'DELETE FROM tasks WHERE id = ?', [id]);
      print('delete: $count');
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());

    }catch (error) {
      print('Error when delete new row: ${error.toString()}');
    }
  }
  bool isBottomSheetShown=false;
  IconData fabIcon=Icons.edit;
  void ChangeBottomSheetState({
    required bool isShow,
    required IconData icon,
} ){
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }
}
