import 'package:flutter/material.dart';
import 'package:myshop/helpers/user.dart';
import 'package:status_alert/status_alert.dart';

class EditMyAddressScreen extends StatefulWidget {
  const EditMyAddressScreen({Key? key}) : super(key: key);

  @override
  EditMyAddressScreenState createState() => EditMyAddressScreenState();
}

class EditMyAddressScreenState extends State<EditMyAddressScreen> {
  final TextEditingController _homeAddressController =
      TextEditingController(text: '');

  final TextEditingController _officeAddressController =
      TextEditingController(text: '');

  String homeAddress = '';
  String officeAddress = '';

  @override
  void initState() {
    getUserData().then((doc) {
      Map<String, dynamic>? docdata = doc.data() as Map<String, dynamic>?;

      setState(() {
        homeAddress = docdata!["homeAddress"] ?? '';
        officeAddress = docdata["officeAddress"] ?? '';

        _homeAddressController.text = homeAddress;
        _officeAddressController.text = officeAddress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _homeAddressController.dispose();
    _officeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit My Address"),
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
                controller: _homeAddressController,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: "Home Address",
                  filled: true,
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _officeAddressController,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: "Office Address",
                  filled: true,
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text("SAVE"),
                onPressed: () {
                  String homeAddressTxt = _homeAddressController.text;
                  String officeAddressTxt = _officeAddressController.text;

                  if (homeAddressTxt != homeAddress ||
                      officeAddressTxt != officeAddress) {
                    editAddress(homeAddressTxt, officeAddressTxt).then((v) {
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
