import 'package:flutter/material.dart';
import 'package:parateste/models/todo.dart';
import 'package:parateste/widgets/todo_list_item.dart';

class ToDoListPage extends StatefulWidget {
  ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          labelText: 'Adicione uma Tarefa',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        String Text = todoController.text;
                        setState(() {
                          Todo newTodo = Todo(
                            title: Text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                        });
                        todoController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black12,
                        backgroundColor: Color(0xff27FF00),
                        shadowColor: Color(0xf000fd04),
                        padding: EdgeInsets.all(8),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes.',
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: showDeleteTodoConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black12,
                        backgroundColor: Color(0xff27FF00),
                        shadowColor: Color(0xf000fd04),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text(
                        'Limpar tudo',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'A tarefa ${todo.title} foi escluída. Desfazer?',
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          textColor: Colors.black,
          backgroundColor: Color(0xff27FF00),
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content:
            Text('Você tem certeza que deseja apagar ${todos.length} terefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xff27FF00),
            ),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              deleteAllTodos();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Color(0xffFF0000),
            ),
            child: Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }
  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
  }
}
