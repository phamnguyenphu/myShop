import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/helpers/user.dart';
import 'package:myshop/pages/order_placed_screen.dart';

class PayOnDeliveryOrderScreen extends StatefulWidget {
  final List cart;
  final double cartItemsTotal;
  final int tax;
  final double taxAmount;
  final double total;

  const PayOnDeliveryOrderScreen(
      {required this.cart,
      required this.cartItemsTotal,
      required this.tax,
      required this.taxAmount,
      required this.total,
      Key? key})
      : super(key: key);

  @override
  PayOnDeliveryOrderScreenState createState() =>
      PayOnDeliveryOrderScreenState();
}

class PayOnDeliveryOrderScreenState extends State<PayOnDeliveryOrderScreen> {
  bool _isLoading = true;
  String addressType = 'home';

  String homeAddress = '';
  String officeAddress = '';

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  loadUserDetails() async {
    try {
      DocumentSnapshot user = await getUserData();
      Map<String, dynamic>? userdata = user.data() as Map<String, dynamic>?;
      String home = userdata!["homeAddress"] ?? '';
      String office = userdata["officeAddress"] ?? '';

      String phone = userdata["phone"] ?? '';

      setState(() {
        _addressController.text = home;
        _phoneController.text = phone;
        homeAddress = home;
        officeAddress = office;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  onBtnPlaceOrderTap() async {
    String address = _addressController.text;
    String phone = _phoneController.text;

    if (address.isNotEmpty && phone.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true;
        });
        DocumentReference ref = await addOrderPayOnDelivery(
          widget.cart,
          widget.cartItemsTotal,
          widget.tax,
          widget.taxAmount,
          widget.total,
          addressType,
          address,
          phone,
        );
        await clearCart();
        setState(() {
          _isLoading = false;
        });
        String orderId = ref.id;
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPlacedScreen(
              orderId: orderId,
              orderMethod: "payOnDelivery",
            ),
          ),
          ModalRoute.withName("/home"),
        );
      } catch (e) {
        debugPrint(e.toString());
        showMyDialog(
          context: context,
          title: "oops",
          description: "Something went wrong, try after some time!",
        );
      }
    } else {
      showMyDialog(
        context: context,
        title: 'oops',
        description: 'Please provide your address, phone',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Screen"),
      ),
      body: _isLoading == true
          ? const Center(
              child: SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Address Type"),
                    Row(
                      children: [
                        Radio(
                          value: 'home',
                          groupValue: addressType,
                          onChanged: (v) {
                            setState(() {
                              addressType = v.toString();
                              _addressController.text = homeAddress;
                            });
                          },
                        ),
                        const Text("Home"),
                        Radio(
                          value: 'office',
                          groupValue: addressType,
                          onChanged: (v) {
                            setState(() {
                              addressType = v.toString();
                              _addressController.text = officeAddress;
                            });
                          },
                        ),
                        const Text("Office"),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: "Address",
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text("Phone"),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: "Phone Number",
                      ),
                      maxLength: 15,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text("Place Order"),
                      onPressed: () {
                        onBtnPlaceOrderTap();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
