import 'package:flutter/material.dart';
import 'package:myshop/helpers/shop.dart';
import 'package:status_alert/status_alert.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({Key? key}) : super(key: key);

  @override
  ShopDetailsScreenState createState() => ShopDetailsScreenState();
}

class ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final TextEditingController shopName = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController taxNumber = TextEditingController();
  final TextEditingController tax = TextEditingController();

  @override
  void initState() {
    super.initState();
    getShopDetails().then((doc) {
      Map<String, dynamic>? shop = doc.data() as Map<String, dynamic>?;
      setState(() {
        shopName.text = shop!["shopName"];
        address.text = shop["address"];
        phone.text = shop["phone"];
        email.text = shop["email"];
        taxNumber.text = shop["taxNumber"];
        tax.text = shop["tax"].toString();
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Details"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: shopName,
                decoration:
                    const InputDecoration(filled: true, labelText: "Shop Name"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: address,
                decoration: const InputDecoration(
                    filled: true, labelText: "Shop Address"),
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: phone,
                decoration:
                    const InputDecoration(filled: true, labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                    filled: true, labelText: "Shop EMail"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: taxNumber,
                decoration: const InputDecoration(
                    filled: true, labelText: "Tax Number"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: tax,
                decoration: const InputDecoration(
                    filled: true, labelText: "Tax Percentage %"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  double taxV = double.parse(tax.text);

                  editShopDetails(
                    address: address.text,
                    email: email.text,
                    phone: phone.text,
                    shopName: shopName.text,
                    tax: taxV,
                    taxNumber: taxNumber.text,
                  ).then((value) {
                    StatusAlert.show(
                      context,
                      title: "Saved",
                      configuration: const IconConfiguration(icon: Icons.done),
                    );
                  }).catchError((e) {
                    debugPrint(e.toString());
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
