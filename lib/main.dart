import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/service/task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tasks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  late bool showCompleted;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    showCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer(builder: (context, ref, _) {
                final notifier = ref.read(taskProvider.notifier);
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration:
                            const InputDecoration(hintText: 'Enter Task Name'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final input = _controller.text.trim();
                        await notifier.addTask(input);
                        _controller.clear();
                      },
                      child: const Text("Add"),
                    ),
                  ],
                );
              }),
            ),
            Row(
              children: [
                Consumer(builder: (context, ref, _) {
                  final notifier = ref.read(taskProvider.notifier);
                  return Checkbox(
                    value: showCompleted,
                    onChanged: (value) {
                      setState(() {
                        showCompleted = value!;
                      });
                      notifier.toggleShowCompleted(showCompleted);
                    },
                  );
                }),
                const Text('Show Completed Tasks'),
              ],
            ),
            Consumer(
              builder: (context, ref, child) {
                final value = ref.watch(taskProvider);
                return value.when(
                  data: (tasks) {
                    return ListView(
                      shrinkWrap: true,
                      children: tasks
                          .map((task) => ListTile(
                                title: Text(task.content),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (!task.completed)
                                      IconButton(
                                        icon: const Icon(Icons.check),
                                        onPressed: () async {
                                          await ref
                                              .read(taskProvider.notifier)
                                              .completeTask(task);
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await ref
                                            .read(taskProvider.notifier)
                                            .deleteTask(task);
                                      },
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    );
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error! $error'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
