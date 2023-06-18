import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todos = [];

  void addTodo(String todo) {
    setState(() {
      todos.add(TodoItem(todo));
    });
  }

  void navigateToTodoPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoPage(addTodo)),
    );
    if (result != null) {
      // Handle any data passed back from the TodoPage
    }
  }

  void navigateToTodoDetailsScreen(TodoItem todo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoDetailsScreen(todo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: ListView.builder(
        itemCount: todos.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Image widget added at the top
            return Image.asset(
              'assets/lists.jpg', // Replace with your image path
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          } else {
            final todo = todos[index - 1];
            return GestureDetector(
              onTap: () => navigateToTodoDetailsScreen(todo),
              child: CheckboxListTile(
                title: Text(todo.title),
                value: todo.completed,
                onChanged: (value) {
                  setState(() {
                    todo.completed = value;
                  });
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToTodoPage,
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoItem {
  String title;
  bool? completed;

  TodoItem(this.title, {this.completed = false});
}

class TodoPage extends StatelessWidget {
  final Function(String) addTodo;
  final TextEditingController _textEditingController = TextEditingController();

  TodoPage(this.addTodo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: 'Todo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final todo = _textEditingController.text;
                if (todo.isNotEmpty) {
                  addTodo(todo);
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoDetailsScreen extends StatelessWidget {
  final TodoItem todo;

  TodoDetailsScreen(this.todo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(todo.title),
            SizedBox(height: 16.0),
            Text(
              'Completed: ${todo.completed != null && todo.completed! ? 'Yes' : 'No'}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
