import 'package:flutter/material.dart';
import 'package:myshop/helpers/user.dart';
import 'package:status_alert/status_alert.dart';

class EditMyPhoneScreen extends StatefulWidget {
  const EditMyPhoneScreen({Key? key}) : super(key: key);

  @override
  EditMyPhoneScreenState createState() => EditMyPhoneScreenState();
}

class EditMyPhoneScreenState extends State<EditMyPhoneScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  final TextEditingController _altPhoneController =
      TextEditingController(text: '');

  String phone = '';
  String altPhone = '';

  @override
  void initState() {
    getUserData().then((doc) {
      Map<String, dynamic>? docdata = doc.data() as Map<String, dynamic>?;
      setState(() {
        phone = docdata!["phone"] ?? '';
        altPhone = docdata["altPhone"] ?? '';

        _phoneController.text = phone;
        _altPhoneController.text = altPhone;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _altPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit My Phone Number"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _phoneController,
                maxLength: 15,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _altPhoneController,
                maxLength: 15,
                decoration: const InputDecoration(
                  labelText: "Alternative Phone",
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text("SAVE"),
                onPressed: () {
                  String phoneInput = _phoneController.text;
                  String altPhoneInput = _altPhoneController.text;

                  if (phoneInput != phone || altPhoneInput != altPhone) {
                    editPhoneNumber(phoneInput, altPhoneInput).then((v) {
                      StatusAlert.show(
                        context,
                        title: "Saved",
                        configuration:
                            const IconConfiguration(icon: Icons.done),
                      );
                      Navigator.pop(context);
                    }).catchError((e) {
                      debugPrint(e.toString());
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
