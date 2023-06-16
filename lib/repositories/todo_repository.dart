import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

const todoListKey = 'todo_list';

class todoRepository {
  TodoRepository() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }
  
  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo> todos) {
    final jsonString =  json.encode(todos);
    print(jsonString);
  }
  
}