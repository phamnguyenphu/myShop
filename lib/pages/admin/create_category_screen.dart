import 'package:flutter/material.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/helpers/category.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({Key? key}) : super(key: key);

  @override
  CreateCategoryScreenState createState() => CreateCategoryScreenState();
}

class CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _titleController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: "Title",
                ),
                maxLength: 60,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty) {
                    createCategory(_titleController.text).then((v) {
                      Navigator.pop(context, "added");
                    }).catchError((e) {
                      debugPrint(e.toString());
                    });
                  } else {
                    showMyDialog(
                      context: context,
                      title: "oops",
                      description: "Provide Category title",
                    );
                  }
                },
                child: const Text("ADD"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
