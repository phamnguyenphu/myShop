import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/config/payment_options.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/helpers/shop.dart';
import 'package:myshop/pages/order_placed_screen.dart';
import 'package:myshop/pages/pay_on_delivery_order_screen.dart';
import 'package:http/http.dart' as http;

import '../config/strings.dart';

class CheckoutScreen extends StatefulWidget {
  final List cart;

  const CheckoutScreen({required this.cart, Key? key}) : super(key: key);

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? paymentIntent;
  bool _loading = true;
  double cartItemsTotal = 0;
  double total = 0;
  double taxAmount = 0;
  int tax = 0;
  late DocumentSnapshot shopDetails;

  @override
  void initState() {
    super.initState();
    preparePayment();
  }

  preparePayment() async {
    // calculate total
    double cartTotal = 0;
    List cart = widget.cart;

    for (var c in cart) {
      double salePrice = c["salePrice"];
      cartTotal += salePrice;
    }

    cartTotal = double.parse(cartTotal.toStringAsFixed(2));

    var shopDetailsFromDB = await getShopDetails();
    Map<String, dynamic>? shopDoc =
        shopDetailsFromDB.data() as Map<String, dynamic>?;
    int taxInt = 0;
    double payableAmount = cartTotal;
    double payableTaxAmount = 0;

    if (shopDetailsFromDB.exists) {
      if (shopDoc!["tax"] != null) {
        double taxDouble = double.parse(shopDoc["tax"].toString());
        taxInt = taxDouble.toInt();

        // calculate percentage of tax
        payableTaxAmount = (cartTotal * taxInt) / 100;
        payableTaxAmount = double.parse(payableTaxAmount.toStringAsFixed(2));

        payableAmount += payableTaxAmount;
      }
    }

    payableAmount = double.parse(payableAmount.toStringAsFixed(2));

    setState(() {
      cartItemsTotal = cartTotal;
      shopDetails = shopDetailsFromDB;
      tax = taxInt;
      taxAmount = payableTaxAmount;
      total = payableAmount;
      _loading = false;
    });
  }

  onBtnPayOnDeliveryTap() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayOnDeliveryOrderScreen(
          cart: widget.cart,
          cartItemsTotal: cartItemsTotal,
          tax: tax,
          taxAmount: taxAmount,
          total: total,
          isPayOnline: false,
        ),
      ),
    );
  }

  onBtnSelfPickupTap() async {
    try {
      DocumentReference ref = await addOrderSelfPickup(
        widget.cart,
        cartItemsTotal,
        tax,
        taxAmount,
        total,
      );
      await clearCart();
      String orderId = ref.id;
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPlacedScreen(
            orderId: orderId,
            orderMethod: "selfPickup",
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
  }

  onBtnVisaPay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayOnDeliveryOrderScreen(
          cart: widget.cart,
          cartItemsTotal: cartItemsTotal,
          tax: tax,
          taxAmount: taxAmount,
          total: total,
          isPayOnline: true,
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan')).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value){
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green,),
                      Text("Payment Successfull"),
                    ],
                  ),
                ],
              ),
            ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;

      }).onError((error, stackTrace){
        print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100 ;
    return calculatedAmout.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: _loading == true
          ? const Center(
              child: SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    // total amout

                    const Text("Total Payable Amount"),
                    Text(
                      "$currencySymbol$total",
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // payment options
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("Payment options:"),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // FlatButton(
                          //   color: Colors.grey[300],
                          //   textColor: Colors.black,
                          //   onPressed: () {},
                          //   child: Text("Pay Online"),
                          // ),

                          if (payOnDelivery) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                onBtnPayOnDeliveryTap();
                              },
                              child: const Text("Pay on Delivery"),
                            ),
                          ],

                          if (selfPickup == true) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                onBtnSelfPickupTap();
                              },
                              child: const Text("Self Pickup"),
                            ),
                          ],

                          if (visaPay == true) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await makePayment();
                                onBtnVisaPay();
                              },
                              child: const Text("Visa / Master Card"),
                            ),
                          ],

                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    // datatable -> total price, tax, fee
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("Payment Details:"),
                          const SizedBox(
                            height: 10,
                          ),
                          DataTable(
                            columns: const [
                              DataColumn(
                                label: Text("Name"),
                              ),
                              DataColumn(
                                label: Text("Amount"),
                              ),
                            ],
                            rows: [
                              DataRow(
                                cells: [
                                  const DataCell(Text("Cart Total")),
                                  DataCell(
                                      Text("$currencySymbol$cartItemsTotal")),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  const DataCell(Text("Tax")),
                                  DataCell(Text(
                                      "$currencySymbol$taxAmount ($tax%)")),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  const DataCell(Text("Total")),
                                  DataCell(Text("$currencySymbol$total")),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }


}
