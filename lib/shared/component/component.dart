import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

Widget defaultButton({
  double width=double.infinity,
  Color background=Colors.blue,
  bool isUpperCase=true,
  double radius=0.0,
  required void Function()? function,
  required String text,
})=>Container(
  width:width,

  child: MaterialButton(
    height: 40,
    onPressed: function,
    child: Text(
      isUpperCase? text.toUpperCase():text,
      style: TextStyle(
          color: Colors.white
      ), ),
  ),

  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius,),
    color: background,
  ),
);
Widget defaultFormField( {
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChanged,
  void Function()? onTap,
  required String? Function(String?)? validate,
  required String label,
  required Widget prefix,
  void Function() ? suffpass,
  bool isPasword=false,
  Widget? suffix =null,
  bool isClickable=true,
})=>TextFormField(
  controller: controller,
  onFieldSubmitted: onSubmit,
  onChanged: onChanged,
  onTap: onTap,
  obscureText: isPasword,
  enabled: isClickable,
  keyboardType: type,
  decoration: InputDecoration(
// hintText: 'Email Address',
    labelText: label,
    prefixIcon: prefix,
    suffixIcon:suffix != null ? IconButton(onPressed:suffpass,
        icon: suffix) :null ,
    border:OutlineInputBorder(),

  ),
  validator: validate,
);
Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(
            '${model['time']}',
  
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
            onPressed:(){
            AppCubit.get(context).updateData(
                status: 'done',
                id: model['id']);
            },
            icon: Icon(
                Icons.check_box,
              color:Colors.green ,
            )
        ),
        IconButton(
            onPressed:(){
              AppCubit.get(context).updateData(
                  status: 'arcived',
                  id: model['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            )
        ),
      ],
    ),
  ),
  onDismissed: (direction){
AppCubit.get(context).deleteData(id: model['id'],);
  },
);