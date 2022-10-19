import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/my_dialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/user.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  UserDetailsScreenState createState() => UserDetailsScreenState();
}

enum SearchBy { email, phone, uid }

class UserDetailsScreenState extends State<UserDetailsScreen> {
  SearchBy? searchBy = SearchBy.email;

  bool _isLoading = false;
  bool _searchSuccess = false;

  late QueryDocumentSnapshot snapshot;
  late Map<String, dynamic>? data;

  void search(String searchValue) {
    if (searchValue.isNotEmpty && searchValue.length > 4) {
      String? key;

      if (searchBy == SearchBy.email) {
        key = "email";
      } else if (searchBy == SearchBy.phone) {
        key = "phone";
      } else if (searchBy == SearchBy.uid) {
        key = "uid";
      }

      setState(() {
        _isLoading = true;
      });
      searchUser(searchValue, key!).then((qSnap) {
        if (qSnap.size == 0) {
          showMyDialog(
            context: context,
            title: "oops",
            description: "No user found!",
          );
          setState(() {
            _searchSuccess = false;
            _isLoading = false;
          });
        } else {
          setState(() {
            _searchSuccess = true;
            _isLoading = false;
            snapshot = qSnap.docs[0];
            data = qSnap.docs[0].data() as Map<String, dynamic>?;
          });
        }
      }).catchError((e) {
        debugPrint(e.toString());
        showMyDialog(
          context: context,
          title: "oops",
          description: "Something went wrong",
        );
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      showMyDialog(
        context: context,
        title: "oops",
        description: "Please write search value",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Search By"),
            ),
            Row(
              children: [
                Radio(
                  value: SearchBy.email,
                  groupValue: searchBy!,
                  onChanged: (value) {
                    setState(() {
                      searchBy = value as SearchBy;
                    });
                  },
                ),
                const Text("Email"),
                Radio(
                  value: SearchBy.phone,
                  groupValue: searchBy,
                  onChanged: (value) {
                    setState(() {
                      searchBy = value as SearchBy;
                    });
                  },
                ),
                const Text("Phone"),
                Radio(
                  value: SearchBy.uid,
                  groupValue: searchBy,
                  onChanged: (value) {
                    setState(() {
                      searchBy = value as SearchBy;
                    });
                  },
                ),
                const Text("User id"),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: TextField(
                decoration: const InputDecoration.collapsed(
                  hintText: "Search",
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (searchValue) {
                  search(searchValue);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_isLoading == true) ...[
              const SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            ],
            if (_searchSuccess == true) ...[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      backgroundImage: CachedNetworkImageProvider(
                        data!["photoURL"],
                      ),
                      radius: 50,
                    ),
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text("Column")),
                      DataColumn(label: Text("Data")),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          const DataCell(Text("User id")),
                          DataCell(SelectableText(data!["uid"])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Name")),
                          DataCell(SelectableText(data!["displayName"])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Email")),
                          DataCell(SelectableText(data!["email"])),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Phone")),
                          DataCell(SelectableText(data!["phone"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Alt. Phone")),
                          DataCell(SelectableText(data!["altPhone"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Address (Home)")),
                          DataCell(SelectableText(data!["homeAddress"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text("Address (Office)")),
                          DataCell(
                              SelectableText(data!["officeAddress"] ?? "")),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
