import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// RiverPodを使ってTodoリストを作成する
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoList(),
      ),
    ),
  );
}

// ✅ Todoアイテムのデータモデル
class TodoItem {
  final String title;
  final bool isDone;

  TodoItem({required this.title, this.isDone = false});

  // ✅ チェック状態を変更するメソッド
  TodoItem copyWith({String? title, bool? isDone}) {
    return TodoItem(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

// ✅ StateNotifierProvider の設定（List<TodoItem> に変更）
final todolistProvider =
    StateNotifierProvider<TodoListNotifier, List<TodoItem>>((ref) {
  return TodoListNotifier();
});

class TodoListNotifier extends StateNotifier<List<TodoItem>> {
  TodoListNotifier() : super([]);

  // ✅ タスクを追加
  void add(String todo) {
    state = [...state, TodoItem(title: todo)];
  }

  // ✅ タスクを削除
  void remove(int index) {
    state = List.from(state)..removeAt(index);
  }

  // ✅ チェック状態を変更する
  void toggle(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(isDone: !state[i].isDone) // ✅ チェック状態を反転
        else
          state[i]
    ];
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todolistProvider);
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Todoリスト'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Todo',
                      hintText: '追加するTodoを入力してください',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      ref
                          .read(todolistProvider.notifier)
                          .add(textController.text);
                      textController.clear();
                    }
                  },
                  child: Text('追加'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : null, // ✅ チェックで打ち消し線
                      color: todo.isDone
                          ? Colors.grey
                          : Colors.black, // ✅ チェックで色変更
                    ),
                  ),
                  tileColor:
                      todo.isDone ? Colors.green[100] : null, // ✅ チェックで背景色を変える
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) {
                      ref
                          .read(todolistProvider.notifier)
                          .toggle(index); // ✅ チェック状態を更新
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(todolistProvider.notifier).remove(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
